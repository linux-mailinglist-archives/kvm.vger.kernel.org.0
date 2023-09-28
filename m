Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ABC527B186E
	for <lists+kvm@lfdr.de>; Thu, 28 Sep 2023 12:43:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231548AbjI1KnC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Sep 2023 06:43:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231582AbjI1KnA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Sep 2023 06:43:00 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AA1119B
        for <kvm@vger.kernel.org>; Thu, 28 Sep 2023 03:42:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695897731;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OsIQH2esLZ9lBTU+WR+vp4IagfZKRYGyDAIQyBrRQDE=;
        b=RdeTU1uwtuxmaE67sYwO/zmVOuUPL0qr1ogN7ijbFvUk3Sca2kYPX1Azn+SGQS7jpLimp/
        TPjYD6jka4ai5yYmLlW7V533Qh5RnO//Z6MG3Wn+pyASiNJZ6zPxkM9fXkmnySc7pxj8v1
        T/96yQ2qf23KO8eH8lTQbo+CODyLNXs=
Received: from mail-lf1-f70.google.com (mail-lf1-f70.google.com
 [209.85.167.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-508-MeQ5dllKNCiXqmxhOm5nxQ-1; Thu, 28 Sep 2023 06:42:10 -0400
X-MC-Unique: MeQ5dllKNCiXqmxhOm5nxQ-1
Received: by mail-lf1-f70.google.com with SMTP id 2adb3069b0e04-5042bc93273so18245529e87.1
        for <kvm@vger.kernel.org>; Thu, 28 Sep 2023 03:42:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695897729; x=1696502529;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=OsIQH2esLZ9lBTU+WR+vp4IagfZKRYGyDAIQyBrRQDE=;
        b=MQ/A+1/r+31emW7jbVY1AAmqloUfWlr6s6YrlRE+V384YEmLzD7wJ5GyBTQxeCASzC
         Wi+r5nyZ8i8qsSrJ3bsh3r6x5Bx2FFoMFa5js3C4CHtoMuCDrCRHBNCIxM9pBlYv+3JO
         umgc9C9SxRA8mAy1iMAn9k6K5itvUkHjOcXit6EHUhScs1pacG7cooLOGdn2+R3iEmni
         qnkItEkkMUQBVNySwQj1862BKtmofwUV8glDqvBndTp1kJ9bxD54N2JlaV5ni1b4M43m
         hk+U3/hg/DTvjzRucrTC+lL4rIPhbBCkXYu+tmsejcIhfKUkDkNgUAxhhuAssZpJbtH/
         /r/w==
X-Gm-Message-State: AOJu0YzYZLKiwpZlhRUT2LJOPiKnQoiJBEiD2XfPJ1fvFlbYdu29B2v0
        uJpvVXYWlZ83hWTsmj6yCBBkHfGxmDb3PBaK5qo3u6f2gHvrOg8toMJ8UW06RZQnEitHPbc76+T
        UOk/gnEZG0K4Y
X-Received: by 2002:a05:6512:2386:b0:500:7f71:e46b with SMTP id c6-20020a056512238600b005007f71e46bmr995989lfv.1.1695897728911;
        Thu, 28 Sep 2023 03:42:08 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFLLgFKQbMJAduzEZl1evB3HNBUyq53sir7xQOrQUBJRpJm8Gc0M8Q2mW2g7oe4Vbltc4zlgw==
X-Received: by 2002:a05:6512:2386:b0:500:7f71:e46b with SMTP id c6-20020a056512238600b005007f71e46bmr995971lfv.1.1695897728708;
        Thu, 28 Sep 2023 03:42:08 -0700 (PDT)
Received: from starship ([89.237.96.178])
        by smtp.gmail.com with ESMTPSA id 22-20020a05600c22d600b0040648217f4fsm2891898wmg.39.2023.09.28.03.42.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Sep 2023 03:42:08 -0700 (PDT)
Message-ID: <7d6bdd4fca0dfdd6528e416510877c3bfd0cbfac.camel@redhat.com>
Subject: Re: [PATCH v2 4/4] KVM: x86: add new nested vmexit tracepoints
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Cc:     Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Sean Christopherson <seanjc@google.com>,
        Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>
Date:   Thu, 28 Sep 2023 13:42:06 +0300
In-Reply-To: <0db86d5f-50d0-db25-e9ee-d92f2f463faf@redhat.com>
References: <20230924124410.897646-1-mlevitsk@redhat.com>
         <20230924124410.897646-5-mlevitsk@redhat.com>
         <0db86d5f-50d0-db25-e9ee-d92f2f463faf@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On, 2023-09-26 у 18:50 +0200, Paolo Bonzini writes:
> On 9/24/23 14:44, Maxim Levitsky wrote:
> > +		trace_kvm_nested_page_fault(fault->address,
> > +				vcpu->arch.ept_fault_error_code,
> 
> Any reason to include vcpu->arch.ept_fault_error_code rather than the 
> injected exit qualification?


The vcpu->arch.ept_fault_error_code is the original exit qualification
which I want to trace as the host error code
captured on ept fault to a new field, but I see new that I can use vmx_get_exit_qual()
to retrieve it again, thus avoiding the overhead.

Also for the injected error code I can use the 'exit_qualification' instead, I think
that I intended to so so but forgot to update the patch.

So something like that works fine for me:

		trace_kvm_nested_page_fault(fault->address,
				vmx_get_exit_qual(vcpu),
				exit_qualification);




Best regards,
	Maxim Levitsky

> 
> Paolo
> 
> > +				fault->error_code);




