Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABAC63DB083
	for <lists+kvm@lfdr.de>; Fri, 30 Jul 2021 03:11:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232810AbhG3BLD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Jul 2021 21:11:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229667AbhG3BLC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Jul 2021 21:11:02 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B51BFC061765
        for <kvm@vger.kernel.org>; Thu, 29 Jul 2021 18:10:57 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id i10so9090088pla.3
        for <kvm@vger.kernel.org>; Thu, 29 Jul 2021 18:10:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=DsDa8w/t7/VXcjTtjhlMutUZ69+V3sKaHAYWUrxvP2w=;
        b=s5WKvm12hxduXD4KaBZVdGFu1auOXhmp85lyVaoRSW/i40OfXQUyx5b0TBXC+zeqll
         Nqfev9udZ9s3S7qMBcWcr4MMCRGeZh7r31GXm49jNsKlnzuv8dtSyh4y4mskTCDsA9S3
         QU3STRyPmpSeRi0qUf64zUJkaUCQxX49L97ZND7xLa0yvKCfzJcEn0y+z0uRBCjegntd
         3ruUl7q66HZI3OLUvqEVPYCCdO4btGXwjs9Rmh2qCQ/vw2CedidiUv8BpS9RHY0MGdMN
         tWRDfn/+oTzIOLFWjJRyiAhPh5NxaQXFiY8x/1ykirixoItlLiu0KTqzifk1So2yfQmX
         kymg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=DsDa8w/t7/VXcjTtjhlMutUZ69+V3sKaHAYWUrxvP2w=;
        b=KM5clqqKShjo6Yfy/9aAmZE1TdvHQNLkf/dicAMaGdrWGVjrTIXJFXQ5tytY+FD22a
         bEc/RCWqHyvuYAN8qJADtvkh8Bz0HucSM8ooey7+u3o6IdvXILBTRi5o69gqg/KTuJrX
         5mvfZMspqshLYe4D6KhsvFOu9XbvYfbFhivZ2F8MHNg9Xl4bSuHCY1xJXWoVkhyCyrID
         qDGtKzRvI6zM6Vwq00phLaWOIOcoAjTyoPDQJgwuiem9mh28UwRu/Ch8C+knY1VVR9FN
         DDI9ewFqrrSL4imJL3lXc0WCWxyfbVE8dkhGqrMr1Zm8w4129y/v6+DAno/ryEOB/MfP
         TnYA==
X-Gm-Message-State: AOAM533HU7CAZeYfVvKdHs/yLLxBykkYS7SMm/DBiMyYOLhYFQRz7V3I
        di6SHl4wDhv2p4O55IpIqjK3SZIRZbTHuQ==
X-Google-Smtp-Source: ABdhPJykHjxFNng8e9pwGpUCl99/cU52oDpwBq5WiOXs/vFkGzZfPrkKkwfN3K7VYIuO2swkU374ZQ==
X-Received: by 2002:aa7:88d4:0:b029:329:be20:a5c with SMTP id k20-20020aa788d40000b0290329be200a5cmr7927892pff.61.1627607456971;
        Thu, 29 Jul 2021 18:10:56 -0700 (PDT)
Received: from google.com (150.12.83.34.bc.googleusercontent.com. [34.83.12.150])
        by smtp.gmail.com with ESMTPSA id h192sm59949pfe.1.2021.07.29.18.10.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Jul 2021 18:10:56 -0700 (PDT)
Date:   Thu, 29 Jul 2021 18:10:53 -0700
From:   Ricardo Koller <ricarkol@google.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        pbonzini@redhat.com, maz@kernel.org, drjones@redhat.com,
        alexandru.elisei@arm.com, eric.auger@redhat.com,
        yuzenghui@huawei.com, vkuznets@redhat.com
Subject: Re: [PATCH v4 3/6] KVM: selftests: Introduce UCALL_UNHANDLED for
 unhandled vector reporting
Message-ID: <YQNRnbuucxcYJT2F@google.com>
References: <20210611011020.3420067-1-ricarkol@google.com>
 <20210611011020.3420067-4-ricarkol@google.com>
 <YQLwP9T4hevAqa7w@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YQLwP9T4hevAqa7w@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 29, 2021 at 06:15:27PM +0000, Sean Christopherson wrote:
> On Thu, Jun 10, 2021, Ricardo Koller wrote:
> > diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
> > index fcd8e3855111..beb76d6deaa9 100644
> > --- a/tools/testing/selftests/kvm/include/kvm_util.h
> > +++ b/tools/testing/selftests/kvm/include/kvm_util.h
> > @@ -349,6 +349,7 @@ enum {
> >  	UCALL_SYNC,
> >  	UCALL_ABORT,
> >  	UCALL_DONE,
> > +	UCALL_UNHANDLED,
> >  };
> 
> ...
> 
> > @@ -1254,16 +1254,13 @@ void vm_install_exception_handler(struct kvm_vm *vm, int vector,
> >  
> >  void assert_on_unhandled_exception(struct kvm_vm *vm, uint32_t vcpuid)
> >  {
> > -	if (vcpu_state(vm, vcpuid)->exit_reason == KVM_EXIT_IO
> > -		&& vcpu_state(vm, vcpuid)->io.port == UNEXPECTED_VECTOR_PORT
> > -		&& vcpu_state(vm, vcpuid)->io.size == 4) {
> > -		/* Grab pointer to io data */
> > -		uint32_t *data = (void *)vcpu_state(vm, vcpuid)
> > -			+ vcpu_state(vm, vcpuid)->io.data_offset;
> > -
> > -		TEST_ASSERT(false,
> > -			    "Unexpected vectored event in guest (vector:0x%x)",
> > -			    *data);
> > +	struct ucall uc;
> > +
> > +	if (get_ucall(vm, vcpuid, &uc) == UCALL_UNHANDLED) {
> 
> UCALL_UNHANDLED is a bit of an odd name.  Without the surrounding context, I would
> have no idea that it's referring to an unhandled event, e.g. my gut reaction would
> be that it means the ucall itself was unhandled. Maybe UCALL_UNHANDLED_EVENT?

I see. I can send a new patch (this was commited as 75275d7fbe) with a
new name. The only name I can think of that's more descriptive would be
UCALL_UNHANDLED_EXCEPTION, but that's even longer.

> It's rather long, but I don't think that will be problematic for any of the code.
> 
> 
> > +		uint64_t vector = uc.args[0];
> > +
> > +		TEST_FAIL("Unexpected vectored event in guest (vector:0x%lx)",
> > +			  vector);
> >  	}
> >  }
> >  
> > -- 
> > 2.32.0.272.g935e593368-goog
> > 
