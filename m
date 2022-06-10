Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC41B545C36
	for <lists+kvm@lfdr.de>; Fri, 10 Jun 2022 08:29:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241779AbiFJG3V (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Jun 2022 02:29:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234725AbiFJG3T (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Jun 2022 02:29:19 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 692E42DCB3B
        for <kvm@vger.kernel.org>; Thu,  9 Jun 2022 23:29:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1654842558; x=1686378558;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=PqFmt3e1TEQPbp0qcurYiVoJcmrz35VT+3lR86veX9Q=;
  b=S96kwjjOIK94tBaqrMtm3LhioyIUhlNn9sDEkVugUAyaR3RTuSZiuaWZ
   VggikxQE/TOP+A75vYOe8O64YCxQU8X1oi6qx1WklxbAR+rKg9Oy/teYl
   FzJMsWCwYDlP8LwpfXfXkDWWGbi+3KChCIVSlhUGImwca2qTf1dmhdC01
   oleRnh/9W8csgNLcH1jR+6mDIo63hlYgysSnYIIrTrfcxxPa4xi5yROuj
   7OlP2rajfHBEKcKOGzVVL7LnkLEqWTYVj+GVVHrjekwR53jGRSGtR5GyG
   uijQgsBiMOF/ugk/JmL0m99OAK84dvyxwzy+gJg9H8NB7No+Fu4XJnygO
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10373"; a="260652817"
X-IronPort-AV: E=Sophos;i="5.91,288,1647327600"; 
   d="scan'208";a="260652817"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jun 2022 23:29:13 -0700
X-IronPort-AV: E=Sophos;i="5.91,288,1647327600"; 
   d="scan'208";a="828071267"
Received: from yangweij-mobl.ccr.corp.intel.com (HELO [10.255.29.27]) ([10.255.29.27])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jun 2022 23:29:11 -0700
Message-ID: <9a03cd78-d432-1f14-5b17-dbd705759297@intel.com>
Date:   Fri, 10 Jun 2022 14:29:08 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [kvm-unit-tests PATCH 0/3] Fix up test failures induced by
 !enable_pmu
Content-Language: en-US
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     kvm@vger.kernel.org,
        "Paolo Bonzini - Distinguished Engineer (kernel-recipes.org) (KVM HoF)" 
        <pbonzini@redhat.com>
References: <20220609083916.36658-1-weijiang.yang@intel.com>
 <7423da17-1c36-8d37-3e1d-5b51b4d7c370@gmail.com>
From:   "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <7423da17-1c36-8d37-3e1d-5b51b4d7c370@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 6/10/2022 8:02 AM, Like Xu wrote:
> On 9/6/2022 4:39 pm, Yang Weijiang wrote:
>> When pmu is disabled via enable_pmu=0, some perf related MSRs or 
>> instructions
>> are not available to VM, this results into some test failures, fix 
>> them in
>> this series.
>
> How about applying it in the x86/unittests.cfg:
>
>     check = /sys/module/kvm/parameters/enable_pmu=N

I'm afraid you mean check enable_pmu=Y for those failing tests?

Let's not hide the defects of the code :-)

>
> and add another pmu_disable.flat to cover all those unavailable 
> expectations ?

A standalone test for !enable_pmu is a good idea, but the checklist is open,

it may be added to the _TODO_ list.

