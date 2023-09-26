Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5B947AF1AC
	for <lists+kvm@lfdr.de>; Tue, 26 Sep 2023 19:21:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231659AbjIZRV2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Sep 2023 13:21:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229570AbjIZRV1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Sep 2023 13:21:27 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6740810A
        for <kvm@vger.kernel.org>; Tue, 26 Sep 2023 10:20:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695748840;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Hl8P0PehXe7JNy/kAUbNrPxe3ImQTd0Amx2bvocE0Xk=;
        b=V8AZ64eRb8sn09UPP4vECchNTbVZVJs1lKoRFEMuwVnV1gqwM3kao1/9AZe5mYX/p7fDPG
        etQjTNGMD/LjZq0x9e/hThUMVPbQ2K0UAxlHTFNeDGUhzCysShGHzlAY/1lxLgSrMx+El3
        AcR7n8uIZkaswrsXFy16XX7s3+4Vpmo=
Received: from mail-ua1-f69.google.com (mail-ua1-f69.google.com
 [209.85.222.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-331-wfVwSlTePqautCYhcZInCQ-1; Tue, 26 Sep 2023 13:20:37 -0400
X-MC-Unique: wfVwSlTePqautCYhcZInCQ-1
Received: by mail-ua1-f69.google.com with SMTP id a1e0cc1a2514c-7ab00f0d672so4742690241.3
        for <kvm@vger.kernel.org>; Tue, 26 Sep 2023 10:20:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695748836; x=1696353636;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Hl8P0PehXe7JNy/kAUbNrPxe3ImQTd0Amx2bvocE0Xk=;
        b=FKU375lCbtylmNPffRgY5euZxyG0ISn5mVYCezv3uCIitrsb74mi5lnxwiS6CjJkHE
         WR2/pSlSy4trCGpbC++Tq9p8iUSKyVoOKd8+QncWFFXmY2QIhGkcl3qnSm9sA0f4RbRb
         Rdo6OidKtHoPcvGFVKD8Y3UYCoseNR1DrrGh+ARRvtG+sii5BiwbXMTUvgp/y2bjR1W4
         lmrXavlpYtUVj4TY+WisgptBL0cqIcOAswN4mW+q/b29NY7jm/d9VEJ1jsfRxqq9co5+
         XLdalDRrx7JZw2DLxNkVvD5FzqvTaWbTtTJeXjVfiZL1W2/xcaM1W90qQ9nQeSEotU99
         ZIWA==
X-Gm-Message-State: AOJu0Yx8RwVoFa/LM4WOHowUPWYh2UlusOuGzfLKa+XDTRDlmQmjRFBA
        ttoI9uOIQ7LrxaI//A710rUhyfhnPKC2xUWYZZYMvAzfHdyHHkiKjktf85MPCJ1LI7XeCCXJvfP
        +3HQmZqTEspDuE2JoMlST2oZQf/Jf
X-Received: by 2002:a67:b40c:0:b0:452:5df8:b951 with SMTP id x12-20020a67b40c000000b004525df8b951mr7866119vsl.25.1695748836510;
        Tue, 26 Sep 2023 10:20:36 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHtG5ssRygCikczLM//vmZQQ56XN5Yc2hah1+LcfqviSBpBhHmQW1yO2wDZk2XQOdJfhfItOO2+2CVLUvw5E8M=
X-Received: by 2002:a67:b40c:0:b0:452:5df8:b951 with SMTP id
 x12-20020a67b40c000000b004525df8b951mr7866096vsl.25.1695748836240; Tue, 26
 Sep 2023 10:20:36 -0700 (PDT)
MIME-Version: 1.0
References: <1b52b557beb6606007f7ec5672eab0adf1606a34.camel@infradead.org>
 <CABgObfZgYXaXqP=6s53=+mYWvOnbgYJiCRct-0ob444sK9SvGw@mail.gmail.com>
 <faec494b6df5ebee5644017c9415e747bd34952b.camel@infradead.org>
 <3dc66987-49c7-abda-eb70-1898181ef3fe@redhat.com> <d3e0c3e9-4994-4808-a8df-3d23487ff9c4@amazon.de>
In-Reply-To: <d3e0c3e9-4994-4808-a8df-3d23487ff9c4@amazon.de>
From:   Paolo Bonzini <pbonzini@redhat.com>
Date:   Tue, 26 Sep 2023 19:20:24 +0200
Message-ID: <CABgObfZb4CvzpnSJxz9saw8PJeo1Y2=0uB9y4_K+Cu9P9FpF6g@mail.gmail.com>
Subject: Re: [RFC] KVM: x86: Allow userspace exit on HLT and MWAIT, else yield
 on MWAIT
To:     Alexander Graf <graf@amazon.de>
Cc:     David Woodhouse <dwmw2@infradead.org>, kvm@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Sean Christopherson <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        Nicolas Saenz Julienne <nsaenz@amazon.es>,
        "Griffoul, Fred" <fgriffo@amazon.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Sep 23, 2023 at 6:44=E2=80=AFPM Alexander Graf <graf@amazon.de> wro=
te:
> On 23.09.23 11:24, Paolo Bonzini wrote:
> > Why do you need it?  You can just use KVM_RUN to go to sleep, and if yo=
u
> > get another job you kick out the vCPU with pthread_kill.  (I also didn'=
t
> > get the VSM reference).
>
> With the original VSM patches, we used to make a vCPU aware of the fact
> that it can morph into one of many VTLs. That approach turned out to be
> insanely intrusive and fragile and so we're currently reimplementing
> everything as VTLs as vCPUs. That allows us to move the majority of VSM
> functionality to user space. Everything we've seen so far looks as if
> there is no real performance loss with that approach.

Yes, that was also what I remember, sharing the FPU somehow while
having separate vCPU file descriptors.

> One small problem with that is that now user space is responsible for
> switching between VTLs: It determines which VTL is currently running and
> leaves all others (read: all other vCPUs) as stopped. That means if you
> are running happily in KVM_RUN in VTL0 and VTL1 gets an interrupt, user
> space needs to stop VTL0 and unpause VTL1 until it triggers VTL_RETURN
> at which point VTL1 stops execution and VTL0 runs again.

That's with IPIs in VTL1, right? I understand now. My idea was, since
we need a link from VTL1 to VTL0 for the FPU, to use the same link to
trigger a vmexit to userspace if source VTL > destination VTL. I am
not sure how you would handle the case where the destination vCPU is
not running; probably by detecting the IPI when VTL0 restarts on the
destination vCPU?

In any case, making vCPUs poll()-able is sensible.

Paolo

> Nicolas built a patch that exposes "interrupt on vCPU is pending" as an
> ioeventfd user space can request. That way, user space can know whenever
> a currently paused vCPU has a pending interrupt and can act accordingly.
> You could use the same mechanism if you wanted to implement HLT in user
> space, but still use an in-kernel LAPIC.

