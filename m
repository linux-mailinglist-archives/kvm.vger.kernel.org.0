Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45F9F561BEC
	for <lists+kvm@lfdr.de>; Thu, 30 Jun 2022 15:51:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235328AbiF3NtN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Jun 2022 09:49:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235381AbiF3Nsn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Jun 2022 09:48:43 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D305140EC
        for <kvm@vger.kernel.org>; Thu, 30 Jun 2022 06:48:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656596913; x=1688132913;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=P0zHNRfIXZH1Me2UypszMCyyYPahfrN1z9yuIkfEy6k=;
  b=h6CURyG+tUtliWSb0eYpbgDUwNeNJrt5Ckzqkg50rIdqL1nUF7sTFNOc
   kF8awC6SCHjviXnAwL/84oFENX1Nnp/OMdwM5MP6T6YH4WjSHEeGNTvw2
   qVvRG75WPLuhfporPucsaFzzlb3BZ3zWIy/aoxm/MBmTL8lKzUe5o43nJ
   YTfZIUadBvQfABBP62XtYSxB2qZsrDxpuzXcVO9P+1PvG0ugXkNn4PKlv
   N4kPesqk84hFoLi9gXf38QY7P7chsrP7uDUyqzi9+ls8fBLtHxkaoYOZE
   dI8NOIeDrX3+6HZ/ouR8+xgFlCbXaRUQ1NYOdJ3nEZHXyJ3/sTQ74AW9f
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10393"; a="265384599"
X-IronPort-AV: E=Sophos;i="5.92,234,1650956400"; 
   d="scan'208";a="265384599"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2022 06:48:32 -0700
X-IronPort-AV: E=Sophos;i="5.92,234,1650956400"; 
   d="scan'208";a="595692058"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.249.172.61]) ([10.249.172.61])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2022 06:48:29 -0700
Message-ID: <33bda32a-9342-2f5d-b8ee-8a92c4be592b@intel.com>
Date:   Thu, 30 Jun 2022 21:48:26 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.10.0
Subject: Re: [PATCH v5 0/8] KVM: x86: Add CMCI and UCNA emulation
Content-Language: en-US
To:     Jue Wang <juew@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        David Matlack <dmatlack@google.com>
Cc:     Tony Luck <tony.luck@intel.com>, kvm@vger.kernel.org,
        Greg Thelen <gthelen@google.com>,
        Jiaqi Yan <jiaqiyan@google.com>
References: <20220610171134.772566-1-juew@google.com>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20220610171134.772566-1-juew@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,NICE_REPLY_A,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/11/2022 1:11 AM, Jue Wang wrote:
> This patch series implement emulation for Corrected Machine Check
> Interrupt (CMCI) signaling and UnCorrectable No Action required (UCNA)
> error injection.
> 

It seems the main purpose of this series is to allow UCNA error 
injection and notify it to guest via CMCI.

But it doesn't emulate CMCI fully. E.g., guest's error threshold of 
MCi_CTL2 doesn't work. It's still controlled by host's value.

