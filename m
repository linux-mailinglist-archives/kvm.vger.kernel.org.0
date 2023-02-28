Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E98D66A5F34
	for <lists+kvm@lfdr.de>; Tue, 28 Feb 2023 20:06:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229876AbjB1TGb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Feb 2023 14:06:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229820AbjB1TG2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Feb 2023 14:06:28 -0500
Received: from smtp-fw-80006.amazon.com (smtp-fw-80006.amazon.com [99.78.197.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6FDC31E0E;
        Tue, 28 Feb 2023 11:06:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1677611178; x=1709147178;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ji1cHpBv5/5kGQg/cBO8SihfSuHNBBaEf12NhCoRr2I=;
  b=GalQ5RvEppT8Kheu5vT8bOufJJz8lBhXr1MwTdBlOALHeh8MuavZ7FOT
   4NGi/bwUqqNQUcsCtCUrdT4nO3GznuHxNBxB5BPI0uEZQ5esX08eHKm1X
   MImeDbEoZAE7OH7dPEHNzDbktMUOZ8D8ABMNkvfKn/KyFeYpcHNXB1I5A
   I=;
X-IronPort-AV: E=Sophos;i="5.98,222,1673913600"; 
   d="scan'208";a="187760472"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-pdx-2c-m6i4x-e7094f15.us-west-2.amazon.com) ([10.25.36.210])
  by smtp-border-fw-80006.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Feb 2023 18:14:42 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-pdx-2c-m6i4x-e7094f15.us-west-2.amazon.com (Postfix) with ESMTPS id E87C940DB9;
        Tue, 28 Feb 2023 18:14:41 +0000 (UTC)
Received: from EX19D002ANA003.ant.amazon.com (10.37.240.141) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.45; Tue, 28 Feb 2023 18:14:41 +0000
Received: from b0f1d8753182.ant.amazon.com (10.106.83.6) by
 EX19D002ANA003.ant.amazon.com (10.37.240.141) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.24; Tue, 28 Feb 2023 18:14:36 +0000
From:   Takahiro Itazuri <itazur@amazon.com>
To:     <bp@alien8.de>
CC:     <dave.hansen@linux.intel.com>, <itazur@amazon.com>,
        <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <mingo@redhat.com>, <pbonzini@redhat.com>, <seanjc@google.com>,
        <tglx@linutronix.de>, <x86@kernel.org>, <zulinx86@gmail.com>
Subject: Re: [PATCH 0/2] KVM: x86: Propagate AMD-specific IBRS bits to guests
Date:   Tue, 28 Feb 2023 18:13:45 +0000
Message-ID: <20230228181345.40837-1-itazur@amazon.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <Y/0jRXzbcbxTjqSS@zn.tnic>
References: <Y/0jRXzbcbxTjqSS@zn.tnic>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.106.83.6]
X-ClientProxiedBy: EX19D042UWB003.ant.amazon.com (10.13.139.135) To
 EX19D002ANA003.ant.amazon.com (10.37.240.141)
X-Spam-Status: No, score=-9.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SORTED_RECIPS,SPF_HELO_NONE,
        SPF_PASS,USER_IN_DEF_SPF_WL autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Date:   Mon, 27 Feb 2023 22:40:21 +0100
From:   Borislav Petkov <bp@alien8.de>
> On Mon, Feb 27, 2023 at 09:05:24PM +0000, Takahiro Itazuri wrote:
> > VMMs retrieve supported CPUID features via KVM_GET_SUPPORTED_CPUID to
> > construct CPUID information to be passed to KVM_SET_CPUID2. Most CPUID
> > feature bits related to speculative attacks are propagated from host
> > CPUID. But AMD processors have AMD-specific IBRS related bits in CPUID
> > Fn8000_0008_EBX (ref: AMD64 Architecture Programmer's Manual Volume 3:
> > General-Purpose and System Instructions) and some bits are not
> > propagated to guests.
> >
> > Enable propagation of these bits to guests, so that VMMs don't have to
> > enable them explicitly based on host CPUID.
> 
> How hard is it for the VMMs to enable them?

Actually it is not so hard. What VMMs need to do is:
1. Get host CPUID value.
2. Check if these bits are set.
3. Modify the return value of KVM_GET_SUPPORTED_CPUID based on step 2.
4. Pass it to KVM_SET_CPUID2.

If these bits are propagated to guests same as other bits, VMMs can
skip the above process.

https://www.kernel.org/doc/Documentation/virtual/kvm/api.txt
> This ioctl returns x86 cpuid features which are supported by both the
> hardware and kvm in its default configuration.  Userspace can use the
> information returned by this ioctl to construct cpuid information (for
> KVM_SET_CPUID2) that is consistent with hardware, kernel, and
> userspace capabilities, and with user requirements (for example, the
> user may wish to constrain cpuid to emulate older hardware, or for
> feature consistency across a cluster).

VMMs trust to some extent that KVM_GET_SUPPORTED_CPUID returns cpuid
information consistent with hardware, although they should not for some
leaves (like CPU topoligy). IMHO, propagating these bits without VMM
actions would be helpful since guests come to know IBRS related
information of processors by default and applies mitigations properly
based on that information.

Best regards,
Takahiro Itazuri

