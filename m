Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A265D257B44
	for <lists+kvm@lfdr.de>; Mon, 31 Aug 2020 16:26:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727993AbgHaO05 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 Aug 2020 10:26:57 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:44184 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726144AbgHaO0z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 31 Aug 2020 10:26:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1598884013;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QvIU0poyjmCP79MUOcMNbyzo4r99Invwa1wgDE4TIrs=;
        b=LBUfYa7GE08d+8En9EIMp4zW6fJvIXH9VEKjH/30uSOxeI/caSvMYJXboum9X6ghsT1F/g
        7Lj08KuXOVXZjKXQhXcbGRgRHLG50T+nNxGOFRotk2lGELqDI7QntRXGwv1OqI788H96TL
        MkZMIsxehFURz9n60MjHGPn5dpB/Yls=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-146-3fuUZUSdNBOe_dSmcoF2zg-1; Mon, 31 Aug 2020 10:26:31 -0400
X-MC-Unique: 3fuUZUSdNBOe_dSmcoF2zg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6733E8015FD;
        Mon, 31 Aug 2020 14:26:29 +0000 (UTC)
Received: from starship (unknown [10.35.206.190])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8193D5D9D3;
        Mon, 31 Aug 2020 14:26:18 +0000 (UTC)
Message-ID: <9225b703c341f935a4ea529f3428345f6820f931.camel@redhat.com>
Subject: Re: [PATCH 3/3] KVM: nSVM: more strict SMM checks when returning to
 nested guest
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Dan Carpenter <dan.carpenter@oracle.com>, kbuild@lists.01.org,
        kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        Joerg Roedel <joro@8bytes.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Ingo Molnar <mingo@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Date:   Mon, 31 Aug 2020 17:26:12 +0300
In-Reply-To: <20200831120112.GH8299@kadam>
References: <20200831120112.GH8299@kadam>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.3 (3.36.3-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2020-08-31 at 15:01 +0300, Dan Carpenter wrote:
> Hi Maxim,
> 
> url:    https://github.com/0day-ci/linux/commits/Maxim-Levitsky/Few-nSVM-bugfixes/20200828-003025
> base:   https://git.kernel.org/pub/scm/virt/kvm/kvm.git linux-next
> config: x86_64-randconfig-m001-20200827 (attached as .config)
> compiler: gcc-9 (Debian 9.3.0-15) 9.3.0
> 
> If you fix the issue, kindly add following tag as appropriate
> Reported-by: kernel test robot <lkp@intel.com>
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> 
> smatch warnings:
> arch/x86/kvm/svm/svm.c:3915 svm_pre_leave_smm() warn: should this be a bitwise op?
> 
> # https://github.com/0day-ci/linux/commit/e2317f8eb1f0e9f731ddbe66ab175be19f3bdaf1
> git remote add linux-review https://github.com/0day-ci/linux
> git fetch --no-tags linux-review Maxim-Levitsky/Few-nSVM-bugfixes/20200828-003025
> git checkout e2317f8eb1f0e9f731ddbe66ab175be19f3bdaf1
> vim +3915 arch/x86/kvm/svm/svm.c
> 
> ed19321fb657121 arch/x86/kvm/svm.c     Sean Christopherson 2019-04-02  3900  static int svm_pre_leave_smm(struct kvm_vcpu *vcpu, const char *smstate)
> 0234bf885236a41 arch/x86/kvm/svm.c     Ladi Prosek         2017-10-11  3901  {
> 05cade71cf3b925 arch/x86/kvm/svm.c     Ladi Prosek         2017-10-11  3902  	struct vcpu_svm *svm = to_svm(vcpu);
> 8c5fbf1a7231078 arch/x86/kvm/svm.c     KarimAllah Ahmed    2019-01-31  3903  	struct kvm_host_map map;
> 59cd9bc5b03f0ba arch/x86/kvm/svm/svm.c Vitaly Kuznetsov    2020-07-10  3904  	int ret = 0;
> 05cade71cf3b925 arch/x86/kvm/svm.c     Ladi Prosek         2017-10-11  3905  
> e2317f8eb1f0e9f arch/x86/kvm/svm/svm.c Maxim Levitsky      2020-08-27  3906  	if (guest_cpuid_has(vcpu, X86_FEATURE_LM)) {
> e2317f8eb1f0e9f arch/x86/kvm/svm/svm.c Maxim Levitsky      2020-08-27  3907  		u64 saved_efer = GET_SMSTATE(u64, smstate, 0x7ed0);
> e2317f8eb1f0e9f arch/x86/kvm/svm/svm.c Maxim Levitsky      2020-08-27  3908  		u64 guest = GET_SMSTATE(u64, smstate, 0x7ed8);
> e2317f8eb1f0e9f arch/x86/kvm/svm/svm.c Maxim Levitsky      2020-08-27  3909  		u64 vmcb = GET_SMSTATE(u64, smstate, 0x7ee0);
> 05cade71cf3b925 arch/x86/kvm/svm.c     Ladi Prosek         2017-10-11  3910  
> ed19321fb657121 arch/x86/kvm/svm.c     Sean Christopherson 2019-04-02  3911  		if (guest) {
> e2317f8eb1f0e9f arch/x86/kvm/svm/svm.c Maxim Levitsky      2020-08-27  3912  			if (!guest_cpuid_has(vcpu, X86_FEATURE_SVM))
> 9ec19493fb86d6d arch/x86/kvm/svm.c     Sean Christopherson 2019-04-02  3913  				return 1;
> e2317f8eb1f0e9f arch/x86/kvm/svm/svm.c Maxim Levitsky      2020-08-27  3914  
> e2317f8eb1f0e9f arch/x86/kvm/svm/svm.c Maxim Levitsky      2020-08-27 @3915  			if (!(saved_efer && EFER_SVME))
>                                                                                                                  ^^
> It looks like bitwise AND was intended.

Oops. Thanks!

Best regards,
	Maxim Levitskky
> 
> e2317f8eb1f0e9f arch/x86/kvm/svm/svm.c Maxim Levitsky      2020-08-27  3916  				return 1;
> e2317f8eb1f0e9f arch/x86/kvm/svm/svm.c Maxim Levitsky      2020-08-27  3917  
> e2317f8eb1f0e9f arch/x86/kvm/svm/svm.c Maxim Levitsky      2020-08-27  3918  			if (kvm_vcpu_map(&svm->vcpu,
> e2317f8eb1f0e9f arch/x86/kvm/svm/svm.c Maxim Levitsky      2020-08-27  3919  					 gpa_to_gfn(vmcb), &map) == -EINVAL)
> e2317f8eb1f0e9f arch/x86/kvm/svm/svm.c Maxim Levitsky      2020-08-27  3920  				return 1;
> e2317f8eb1f0e9f arch/x86/kvm/svm/svm.c Maxim Levitsky      2020-08-27  3921  
> e2317f8eb1f0e9f arch/x86/kvm/svm/svm.c Maxim Levitsky      2020-08-27  3922  			ret = enter_svm_guest_mode(svm, vmcb, map.hva);
> 69c9dfa24bb7bac arch/x86/kvm/svm/svm.c Paolo Bonzini       2020-05-13  3923  			kvm_vcpu_unmap(&svm->vcpu, &map, true);
> 05cade71cf3b925 arch/x86/kvm/svm.c     Ladi Prosek         2017-10-11  3924  		}
> e2317f8eb1f0e9f arch/x86/kvm/svm/svm.c Maxim Levitsky      2020-08-27  3925  	}
> 59cd9bc5b03f0ba arch/x86/kvm/svm/svm.c Vitaly Kuznetsov    2020-07-10  3926  
> 59cd9bc5b03f0ba arch/x86/kvm/svm/svm.c Vitaly Kuznetsov    2020-07-10  3927  	return ret;
> 0234bf885236a41 arch/x86/kvm/svm.c     Ladi Prosek         2017-10-11  3928  }
> 
> ---
> 0-DAY CI Kernel Test Service, Intel Corporation
> https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org


