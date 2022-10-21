Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9814E6079ED
	for <lists+kvm@lfdr.de>; Fri, 21 Oct 2022 16:51:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230224AbiJUOvD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Oct 2022 10:51:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229975AbiJUOu4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Oct 2022 10:50:56 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A7FF237FA9
        for <kvm@vger.kernel.org>; Fri, 21 Oct 2022 07:50:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666363853;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=3KqX3cQJyXO8DgUbmcCGSuro7kDodg56LrRmLb6OdXw=;
        b=OZIyj/WHC7p0dIVyBw1CMRqMXBRSnDdIC77mntdbBb1z4sTlp6N1uU3QnRW2Qad1ZMHFvZ
        SNi3zW9D7SOUVMmnfG+hN/ppFHyf+0aAjay8Agsvihg+YF7456rxZ40XKwqGJGSsjDHbUj
        XADg1E8Nf5Tn1e6vxMt+mbx7lYzi6cQ=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-365-wtoZBWPVN4CUewQCQc77Sw-1; Fri, 21 Oct 2022 10:50:52 -0400
X-MC-Unique: wtoZBWPVN4CUewQCQc77Sw-1
Received: by mail-ed1-f71.google.com with SMTP id w20-20020a05640234d400b0045d0d1afe8eso2760006edc.15
        for <kvm@vger.kernel.org>; Fri, 21 Oct 2022 07:50:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3KqX3cQJyXO8DgUbmcCGSuro7kDodg56LrRmLb6OdXw=;
        b=0vnOJLWBna4j6SKpNdsucdX9DsABLqVzvGL4+s3j4+SOZHtR5HDG4yyNYboJ2gGmY9
         +/+kqX0jGVXbdOWWatyKcUIVrLAXxBvogM4mD4dqSkZWTNx64qJTIhfIr+EaUbG7wiX3
         TaXfaM+iQT55sIquBvDRuU7WP5J9Sn7fSt2WWegPDBo3Gmdw0byAiXSa5KSLO+V/cXVS
         CxzZI6HIe894JKW+9FA6oJOXY5Z1f5Q2P5kJBv+eVay+Ue+sN2Wj2FezYl3XM8GDxqZ6
         e7mbEHfgexxUQULd3imW100CXSxC3GqaGRGBr3iSp++cVyRBrmUtr/t2IlWKwnyzvmLN
         DwOA==
X-Gm-Message-State: ACrzQf3Ky82BaiszgXWi/qU02dFqhjtjRtT4+3eKYqYbzEpGwwWpO2Ub
        VgVl7uICXo6qGLPmOC1cXohXwbPJicRsjLyibMJuufkCbGBQng6c+Tw2G9J7deKmkKibtqx07nl
        CrroA2NgGXXwq
X-Received: by 2002:a05:6402:2b8d:b0:43a:5410:a9fc with SMTP id fj13-20020a0564022b8d00b0043a5410a9fcmr18067369edb.99.1666363851550;
        Fri, 21 Oct 2022 07:50:51 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM5J8Tepa5KCpS+HvcbR1Fjb2ekWhuUACSZhePPlBCOVX120kQfGnZ0JJY3aPy+j1VOKboUWWQ==
X-Received: by 2002:a05:6402:2b8d:b0:43a:5410:a9fc with SMTP id fj13-20020a0564022b8d00b0043a5410a9fcmr18067350edb.99.1666363851353;
        Fri, 21 Oct 2022 07:50:51 -0700 (PDT)
Received: from ovpn-192-65.brq.redhat.com (nat-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id ku16-20020a170907789000b0078ca30ee18bsm11857943ejc.95.2022.10.21.07.50.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Oct 2022 07:50:50 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        Yuan Yao <yuan.yao@linux.intel.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v11 44/46] KVM: selftests: evmcs_test: Introduce L2 TLB
 flush test
In-Reply-To: <Y1B35gupSqXAvAOZ@google.com>
References: <20221004123956.188909-1-vkuznets@redhat.com>
 <20221004123956.188909-45-vkuznets@redhat.com>
 <Y1B35gupSqXAvAOZ@google.com>
Date:   Fri, 21 Oct 2022 16:50:49 +0200
Message-ID: <87wn8tb586.fsf@ovpn-192-65.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <seanjc@google.com> writes:

> On Tue, Oct 04, 2022, Vitaly Kuznetsov wrote:

...

>>  
>> +	/* L2 TLB flush setup */
>> +	current_evmcs->partition_assist_page = hv_pages->partition_assist_gpa;
>> +	current_evmcs->hv_enlightenments_control.nested_flush_hypercall = 1;
>> +	current_evmcs->hv_vm_id = 1;
>> +	current_evmcs->hv_vp_id = 1;
>> +	current_vp_assist->nested_control.features.directhypercall = 1;
>> +	*(u32 *)(hv_pages->partition_assist) = 0;
>> +
>>  	GUEST_ASSERT(!vmlaunch());
>
> Pre-existing code, but would it make sense to add an assert here to verify L2
> exited due to an NMI?  Feel free to ignore this for now if it's not straightforward,
> this series is plenty big :-)
>

Well, simple

+       GUEST_ASSERT_EQ(vmreadz(VM_EXIT_REASON), EXIT_REASON_EXCEPTION_NMI);
+       GUEST_ASSERT_EQ((vmreadz(VM_EXIT_INTR_INFO) & 0xff), NMI_VECTOR);

seems to be working (passing) so why not :-)

-- 
Vitaly

