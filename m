Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 374754F6D86
	for <lists+kvm@lfdr.de>; Wed,  6 Apr 2022 23:54:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237084AbiDFVzn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Apr 2022 17:55:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236568AbiDFVzM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Apr 2022 17:55:12 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49A171020
        for <kvm@vger.kernel.org>; Wed,  6 Apr 2022 14:51:19 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id 125so3273934pgc.11
        for <kvm@vger.kernel.org>; Wed, 06 Apr 2022 14:51:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=koQM8xA2BKIxu931jCtUHEyhwLbWyOVNzrZPe0cdI/o=;
        b=ka9C/dorFhtBGF6m0S4WRAgqeIS4O1JcWK7BIfF8pO0RIWWymKpAk0m69qYEPmQSYD
         f1D+C6J2lR7YYsDak7etINqttBK6G76/911kW6J0+X9+8N/z5C8QkpRM3DE4YH53OcOg
         rN5vNRYfxEchcX5qh59JIjHcdafZnWBNyp1q2GI/bz/MpPDxwQQLqrSYj+UNIamGBuHf
         RwqLLmpneb/GGkJ6W71Hn2+Xf8lYlPc/9XpfQ8rC/PYEgkF5OMlHcswueTOs+iDLqCYR
         xS+aLAs67w6mL04J8XNeEN83QfoQbTaLSwgP1T5MI32YuEbI5RGVSm9CxtPB0Lgmf1eW
         /7yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=koQM8xA2BKIxu931jCtUHEyhwLbWyOVNzrZPe0cdI/o=;
        b=tJ7tR10h3djz2DFodGDCj5HPQxT35MzGNikPCipQqiXGqoinIUo0IPiQOMoQAnW8V2
         KOCM3EjueRR3IuwXk+dFyHAg1gb28qWEFHc508MheOzL0aLqGSGduPBSg0QwGGBEmbwm
         hWDd4lUX0YX10GebWlJ3TNa1QXIwlxDzTzXIhk9EjGmgUgpDve81I7QnXbOONpZTWDqk
         UNacMlWzRk37VcqWeVfTErBOfwQ/aWGBtIokT5epTXN5U7WOmoMonHxH2v+LPc2tjPQC
         wJWaoPvbQGsXiQLiAy+e2s+bK3+tZBApgSdX8Red9FxKt2nmSPk2DFzk9N9j/1NBKsHG
         zBdA==
X-Gm-Message-State: AOAM533pYcMXjBAdY/QVnZpnf0mq9xEMgPuVsN3i3oDopWn51tuGIPx7
        SrmoeZSSeoa5KfnlyLJQBwYW/g==
X-Google-Smtp-Source: ABdhPJzyHPkhUgiuuxECQtttoEhHy3d6hStlo2vatAwsXuRttGOOXqmfjyACKSNWYEz1RbyDmt27uA==
X-Received: by 2002:a05:6a00:140e:b0:4e1:c81a:625c with SMTP id l14-20020a056a00140e00b004e1c81a625cmr10858620pfu.39.1649281878633;
        Wed, 06 Apr 2022 14:51:18 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id j22-20020a056a00235600b004faed937407sm21782456pfj.19.2022.04.06.14.51.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Apr 2022 14:51:17 -0700 (PDT)
Date:   Wed, 6 Apr 2022 21:51:14 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Chenyi Qiang <chenyi.qiang@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Xiaoyao Li <xiaoyao.li@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 1/3] KVM: X86: Save&restore the triple fault request
Message-ID: <Yk4LUqpQQxYNkaer@google.com>
References: <20220318074955.22428-1-chenyi.qiang@intel.com>
 <20220318074955.22428-2-chenyi.qiang@intel.com>
 <YkzRSHHDMaVBQrxd@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YkzRSHHDMaVBQrxd@google.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 05, 2022, Sean Christopherson wrote:
> On Fri, Mar 18, 2022, Chenyi Qiang wrote:
> > @@ -4903,7 +4906,8 @@ static int kvm_vcpu_ioctl_x86_set_vcpu_events(struct kvm_vcpu *vcpu,
> >  			      | KVM_VCPUEVENT_VALID_SIPI_VECTOR
> >  			      | KVM_VCPUEVENT_VALID_SHADOW
> >  			      | KVM_VCPUEVENT_VALID_SMM
> > -			      | KVM_VCPUEVENT_VALID_PAYLOAD))
> > +			      | KVM_VCPUEVENT_VALID_PAYLOAD
> > +			      | KVM_VCPUEVENT_TRIPLE_FAULT))
> >  		return -EINVAL;
> >  
> >  	if (events->flags & KVM_VCPUEVENT_VALID_PAYLOAD) {
> > @@ -4976,6 +4980,9 @@ static int kvm_vcpu_ioctl_x86_set_vcpu_events(struct kvm_vcpu *vcpu,
> >  		}
> >  	}
> >  
> > +	if (events->flags & KVM_VCPUEVENT_TRIPLE_FAULT)
> > +		kvm_make_request(KVM_REQ_TRIPLE_FAULT, vcpu);
> > +
> >  	kvm_make_request(KVM_REQ_EVENT, vcpu);
> 
> Looks correct, but this really needs a selftest, at least for the SET path since
> the intent is to use that for the NOTIFY handling.  Doesn't need to be super fancy,
> e.g. do port I/O from L2, inject a triple fault, and verify L1 sees the appropriate
> exit.

It finally dawned on me why all the other events use two "flags", i.e. an actual
flags entry of KVM_VCPUEVENT_VALID_* and then the value itself.  Userspace needs
to be able to _clear_ the request, not just set the request.  So this needs to
follow the existing pattern of adding a VALID flag and then yet another field to
specify whether or not a triple fault is pending.
