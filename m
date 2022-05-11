Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1DBEE523A48
	for <lists+kvm@lfdr.de>; Wed, 11 May 2022 18:26:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240897AbiEKQ00 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 May 2022 12:26:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344795AbiEKQ0S (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 May 2022 12:26:18 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id BC062340F4
        for <kvm@vger.kernel.org>; Wed, 11 May 2022 09:26:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652286376;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=oEtf9aEeYwcmbS2Abb6hgTNVW6CzU6LHwK+SuywPU4E=;
        b=hOMCVuaKkidY5s+DrgZRgGVDBxqk9XpCaXCYzEhpvQWWZevV3KHFWpeJ1GpnqBcy3yWvw9
        OA8gnxeEsF2vVkm8F+Sk+o0ub58xiWf52JfrYZpk4vrMWf3eL+7ks1TQJJX5Mb+G6G3lMP
        T8ZscixYZ0OHGvuuD+pmLXon4DhTOKU=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-588-vGclDIA-Or2DVEoORY-m7Q-1; Wed, 11 May 2022 12:26:13 -0400
X-MC-Unique: vGclDIA-Or2DVEoORY-m7Q-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 90B9B1D32371;
        Wed, 11 May 2022 16:26:12 +0000 (UTC)
Received: from starship (unknown [10.40.192.26])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 143462026D6A;
        Wed, 11 May 2022 16:26:06 +0000 (UTC)
Message-ID: <858cdb9c2c1cc1deda179fc534ad42de1275920f.camel@redhat.com>
Subject: Re: [PATCH v4 10/15] KVM: SVM: Introduce helper functions to
 (de)activate AVIC and x2AVIC
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, seanjc@google.com, joro@8bytes.org,
        jon.grimm@amd.com, wei.huang2@amd.com, terry.bowman@amd.com,
        kernel test robot <lkp@intel.com>
Date:   Wed, 11 May 2022 19:26:05 +0300
In-Reply-To: <3fa12834-d144-54d8-0bf8-8a72e726db99@amd.com>
References: <20220508023930.12881-1-suravee.suthikulpanit@amd.com>
         <20220508023930.12881-11-suravee.suthikulpanit@amd.com>
         <a60d885cf4b0b11aca730273ff317546362bff83.camel@redhat.com>
         <3fa12834-d144-54d8-0bf8-8a72e726db99@amd.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2022-05-11 at 22:37 +0700, Suravee Suthikulpanit wrote:
> Maxim,
> 
> On 5/9/22 8:42 PM, Maxim Levitsky wrote:
> > ...
> > 
> > So I did some testing, and reviewed this code again with regard to nesting,
> > and now I see that it has CVE worthy bug, so have to revoke my Reviewed-By.
> > 
> > This is what happens:
> > 
> > On nested VM entry, *request to inhibit AVIC is done*, and then nested msr bitmap
> > is calculated, still with all X2AVIC msrs open,
> > 
> > 1. nested_svm_vmrun -> enter_svm_guest_mode -> kvm_make_request(KVM_REQ_APICV_UPDATE, vcpu);
> > 2. nested_svm_vmrun -> nested_svm_vmrun_msrpm
> > 
> > But the nested guest will be entered without AVIC active
> > (since we don't yet support nested avic and it is optional anyway), thus if the nested guest
> > also doesn't intercept those msrs, it will gain access to the *host* x2apic msrs. Ooops.
> 
> Shouldn't this be changed to intercept the x2APIC msrs because of the following logic?
> 
> kvm_make_request(KVM_REQ_APICV_UPDATE, vcpu)
>      kvm_vcpu_update_apicv(vcpu)
>          static_call(kvm_x86_refresh_apicv_exec_ctrl)(vcpu)
>              avic_deactivate_vmcb()
>                  svm_set_x2apic_msr_interception(true)

Nope because the above only updates L1 msr intercept bitmap, while 'merged'
msr bitmap that L2 uses still has those msrs open.

Other and better way to fix it would be to fix set_msr_interception
to update the merged bitmap as well.

I think I will post a patch series to clean up this mess soon.

Best regards,
	Maxim Levitsky

> 
> > I think the easist way to fix this for now, is to make nested_svm_vmrun_msrpm
> > never open access to x2apic msrs regardless of the host bitmap value, but in the long
> > term the whole thing needs to be refactored.
> 
> Agree.
> 
> > Another thing I noted is that avic_deactivate_vmcb should not touch avic msrs
> > when avic_mode == AVIC_MODE_X1, it is just a waste of time.
> 
> We can add the check.
> 
> > Also updating these msr intercepts is pointless if the guest doesn't use x2apic.
> 
> We can also add the check.
> 
> Best Regards,
> Suravee
> 


