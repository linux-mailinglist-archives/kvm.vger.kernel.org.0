Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B20554C136
	for <lists+kvm@lfdr.de>; Wed, 15 Jun 2022 07:43:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238751AbiFOFdw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Jun 2022 01:33:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234510AbiFOFdv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Jun 2022 01:33:51 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B917F49F83
        for <kvm@vger.kernel.org>; Tue, 14 Jun 2022 22:33:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655271230; x=1686807230;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=d7t339grLpqlhNNESGUxLpA2BKb5q2L+gVUe5y5cn9Y=;
  b=L489fK40clT3bQSLeyXxPMwBArZUB40fPB5RT1kPhSyDlb7Qkrp2JWc1
   RXDyTJY2XXeZpX8OUQa6IH5q8DncIyrovBM6OqH+pJV6/A99aN1/YcQNH
   4SDrkFQ5HInW1f99MivHVZBgJYJfJC62A2u+9f2gRiAp7w8vm3kjQhuLc
   eenhswCppdVuVEciWrSR4IxG9HEBBBRKRHPjxXPOSi3hIoGaAtC0AwQw6
   pju9K6O+pxgTu5Th7cUo7NPjX26bpETM9h/66gR+VE61IxBK/AdHpsCiw
   TuZ77rQtahsofs08dRyzdzZes2q1queKZLFJZPeFv6isP9ligr+m26HC2
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10378"; a="258694125"
X-IronPort-AV: E=Sophos;i="5.91,300,1647327600"; 
   d="scan'208";a="258694125"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jun 2022 22:33:50 -0700
X-IronPort-AV: E=Sophos;i="5.91,300,1647327600"; 
   d="scan'208";a="830844473"
Received: from gao-cwp.sh.intel.com (HELO gao-cwp) ([10.239.159.23])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jun 2022 22:33:47 -0700
Date:   Wed, 15 Jun 2022 13:33:34 +0800
From:   Chao Gao <chao.gao@intel.com>
To:     "Wang,Guangju" <wangguangju@baidu.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>,
        "jmattson@google.com" <jmattson@google.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "dave.hansen@linux.intel.co" <dave.hansen@linux.intel.co>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.orga" <linux-kernel@vger.kernel.orga>
Subject: Re: =?utf-8?B?562U5aSNOiBbUEFUQ0hdIEtWTTog?= =?utf-8?Q?x86=3A?= add
 a bool variable to distinguish whether to use PVIPI
Message-ID: <20220615053329.GA13836@gao-cwp>
References: <1655124522-42030-1-git-send-email-wangguangju@baidu.com>
 <YqdxAFhkeLjvi7L5@google.com>
 <20220614025434.GA15042@gao-cwp>
 <YqieGua0ouUePWol@google.com>
 <20220614150319.GA13174@gao-cwp>
 <aa618267a02c4ca9b10d75b5035b92d0@baidu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aa618267a02c4ca9b10d75b5035b92d0@baidu.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Spam-Status: No, score=-5.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 15, 2022 at 04:21:21AM +0000, Wang,Guangju wrote:
>>On Mon, Jun 13, 2022 at 05:16:48PM +0000, Sean Christopherson wrote:
>>>The shortlog is not at all helpful, it doesn't say anything about what 
>>>actual functional change.
>>>
>>>  KVM: x86: Don't advertise PV IPI to userspace if IPIs are virtualized
>>>
>>>On Mon, Jun 13, 2022, wangguangju wrote:
>>>> Commit d588bb9be1da ("KVM: VMX: enable IPI virtualization") enable 
>>> >IPI virtualization in Intel SPR platform.There is no point in using 
>>> >PVIPI if IPIv is supported, it doesn't work less good with PVIPI than 
>>> >without it.
>>>> 
>>> >So add a bool variable to distinguish whether to use PVIPI.
>>>
>>>Similar complaint with the changelog, it doesn't actually call out why 
>>>PV IPIs are unwanted.
>>>
>>>  Don't advertise PV IPI support to userspace if IPI virtualization is  
>> >supported by the CPU.  Hardware virtualization of IPIs more performant  
>> >as senders do not need to exit.
>
>>PVIPI is mainly [*] for sending multi-cast IPIs. Intel IPI virtualization can virtualize only uni-cast IPIs. Their use cases don't overlap. So, I don't think it makes sense to disable PVIPI if intel IPI virtualization is supported.
>A question, like x2apic mode, guest uses PVIPI with replace apic->send_IPI_mask to kvm_send_ipi_mask. The original function implementation is __x2apic_send_IPI_mask , and it poll each CPU to send IPI. So in this case 
>Intel virtualization can not work? Thanks.

Yes, it can work. But some experiments we conducted based on a modified
kvm-unit-test showed that PVIPI outperforms native ICR writes (w/ IPI
virtualization) in terms of sending multi-cast (i.e., dest vCPUs >=2) IPIs
