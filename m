Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9394C4AEB6B
	for <lists+kvm@lfdr.de>; Wed,  9 Feb 2022 08:49:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239110AbiBIHs5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Feb 2022 02:48:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237374AbiBIHsz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Feb 2022 02:48:55 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7E30C0613CB;
        Tue,  8 Feb 2022 23:48:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1644392939; x=1675928939;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=UHxQ0y6ReTg5fAil+JKwO37ROUMI1ZBKsYOkDDrvDa0=;
  b=JAKJTt7lQ3ErEl1627tkNZltivTKJCYgoSsISDIzydbmgqDXe5PULrxB
   EIfJx62CVNN6HebphBDc/DnD+HsJW+d3nPGZvogpDXBV8gHgPFl9Ii5oC
   V9atX26WowaahJXqHSYPu5Bl65ZAOx+vOKQKHd1I6rQkUyL4UDlZJQCH+
   5AMwdrkE0Pw18bdf5ceUMNHldCzx4c9Bqo+gSo+8HqagjS7R0K0i0QKl6
   Aih6qw0SL+oZrC1yCNFsgdtOFgEad2wDOD4fewyNeGRxOxZ1uNwtEp8KA
   lEintS/aIaQq0l308ODwwZJQ4PqmwnNbg3BE4JYvp4vsfh/gfGY6I70fL
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10252"; a="273682787"
X-IronPort-AV: E=Sophos;i="5.88,355,1635231600"; 
   d="scan'208";a="273682787"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Feb 2022 23:48:59 -0800
X-IronPort-AV: E=Sophos;i="5.88,355,1635231600"; 
   d="scan'208";a="525893576"
Received: from gao-cwp.sh.intel.com (HELO gao-cwp) ([10.239.159.105])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Feb 2022 23:48:56 -0800
Date:   Wed, 9 Feb 2022 15:59:51 +0800
From:   Chao Gao <chao.gao@intel.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, kevin.tian@intel.com,
        tglx@linutronix.de, John Garry <john.garry@huawei.com>,
        Will Deacon <will@kernel.org>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Shaokun Zhang <zhangshaokun@hisilicon.com>,
        Thomas Richter <tmricht@linux.ibm.com>,
        Tony Lindgren <tony@atomide.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 3/4] KVM: Rename and move CPUHP_AP_KVM_STARTING to
 ONLINE section
Message-ID: <20220209075950.GA7943@gao-cwp>
References: <20220118064430.3882337-1-chao.gao@intel.com>
 <20220118064430.3882337-4-chao.gao@intel.com>
 <YgMLBYl7P1jFA2xe@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YgMLBYl7P1jFA2xe@google.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 09, 2022 at 12:29:57AM +0000, Sean Christopherson wrote:
>On Tue, Jan 18, 2022, Chao Gao wrote:
>> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
>> index 148f7169b431..528741601122 100644
>> --- a/virt/kvm/kvm_main.c
>> +++ b/virt/kvm/kvm_main.c
>> @@ -4856,13 +4856,25 @@ static void hardware_enable_nolock(void *junk)
>>  	}
>>  }
>>  
>> -static int kvm_starting_cpu(unsigned int cpu)
>> +static int kvm_online_cpu(unsigned int cpu)
>>  {
>> +	int ret = 0;
>> +
>>  	raw_spin_lock(&kvm_count_lock);
>> -	if (kvm_usage_count)
>> +	/*
>> +	 * Abort the CPU online process if hardware virtualization cannot
>> +	 * be enabled. Otherwise running VMs would encounter unrecoverable
>> +	 * errors when scheduled to this CPU.
>> +	 */
>> +	if (kvm_usage_count) {
>
>
>>  		hardware_enable_nolock(NULL);
>> +		if (atomic_read(&hardware_enable_failed)) {
>
>This needs:
>
>		atomic_set(&hardware_enable_failed, 0);
>
>otherwise failure to online one CPU will prevent onlining other non-broken CPUs.
>It's probably worth adding a WARN_ON_ONCE above this too, e.g.

Thanks. All your comments to this series make sense. I just post a revised
version.
