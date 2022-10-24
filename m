Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7863C60ADC2
	for <lists+kvm@lfdr.de>; Mon, 24 Oct 2022 16:33:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235274AbiJXOdg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Oct 2022 10:33:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230499AbiJXOdT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Oct 2022 10:33:19 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE211DBE64
        for <kvm@vger.kernel.org>; Mon, 24 Oct 2022 06:07:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666616715;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=y561vb2yhJEYgO64sDu4Qoo1CR5Dt5Qkh+kUWYcjlSw=;
        b=JC3Mlt//QVmW8c6qYnekzoWziJeUrpMgO5Na0XyvXslRzvKbL5NBwFa4kc0Y0spTA5RPFk
        Csy2yDe+AqDEkXUR2YZg1UEUa8QZxa3OY4HX0s12Ckip8vzyJF44hwAzq4hv3JsiXhxC8o
        7Mo3u4zgsZJzb1tK7a1113GMvOR3RqI=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-468-e3WfIShiNWehgg5xOtVvTw-1; Mon, 24 Oct 2022 08:39:21 -0400
X-MC-Unique: e3WfIShiNWehgg5xOtVvTw-1
Received: by mail-qv1-f72.google.com with SMTP id ng1-20020a0562143bc100b004bb706b3a27so989924qvb.20
        for <kvm@vger.kernel.org>; Mon, 24 Oct 2022 05:39:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=y561vb2yhJEYgO64sDu4Qoo1CR5Dt5Qkh+kUWYcjlSw=;
        b=hkqbYeiTC7/oK+O0sHk7uAg345jArtfD1WHagVeWviva1Q09caHPP9hp1Yjp8gyAkq
         58MncsWHvAWjtDJrmvwg6/1Uf5lDqfe6VEmet2GceHjmjcS+6vk0mifRvVQDKSdvioOi
         DoTnqB9AvfyvZhH5zlM5gdd+nRpOvZ896lezpTUIEC7UV0hX75a2Aa7YoDa7ijfvrm9t
         bwkqWIFvaK54tryrc2/+W8rGMEMR7sypM7TP6gAVl9mRug5eLqi0TTKMUQuacweLtmhM
         9Dm4+/jwi68xCZigOCwxryMavS8RtgLdfRiEIgFbmr1PfcBpnUWqszS6tNTQr1FZ/KJX
         3DUQ==
X-Gm-Message-State: ACrzQf02JutqjBpSxGFPVBUymdgwDbBSDe3+v7j58UWsYV4hPnpsoXAo
        u++ApbcNycF5SOhvFG59hIX7Z5INsmsEiOub6pgOWdxLOINrUzoBuqyVNtpGkXwmtovaZfekJJ0
        urkHT/tCCJw1a
X-Received: by 2002:a05:620a:6004:b0:6cf:3ee4:56e0 with SMTP id dw4-20020a05620a600400b006cf3ee456e0mr14362156qkb.200.1666615161093;
        Mon, 24 Oct 2022 05:39:21 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM71t8d8xYHVOhKN1lTDGKvlXYDLfVERyEdVvW8ejyfR3Gd48S4cItG90IW+EdnjvL7CI31cfA==
X-Received: by 2002:a05:620a:6004:b0:6cf:3ee4:56e0 with SMTP id dw4-20020a05620a600400b006cf3ee456e0mr14362143qkb.200.1666615160867;
        Mon, 24 Oct 2022 05:39:20 -0700 (PDT)
Received: from [10.35.4.238] (bzq-82-81-161-50.red.bezeqint.net. [82.81.161.50])
        by smtp.gmail.com with ESMTPSA id j12-20020a05620a288c00b006b640efe6dasm14836057qkp.132.2022.10.24.05.39.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Oct 2022 05:39:20 -0700 (PDT)
Message-ID: <bd2576767845b807cbeac191e0b0aa1074677c58.camel@redhat.com>
Subject: Re: [kvm-unit-tests PATCH 08/16] svm: add nested shutdown test.
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, Cathy Avery <cavery@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Date:   Mon, 24 Oct 2022 15:39:17 +0300
In-Reply-To: <Y1GcQ1vJptwmUtga@google.com>
References: <20221020152404.283980-1-mlevitsk@redhat.com>
         <20221020152404.283980-9-mlevitsk@redhat.com>
         <4f991c306dca5764c5822fca43f8092001817790.camel@redhat.com>
         <Y1GcQ1vJptwmUtga@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.40.4 (3.40.4-5.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2022-10-20 at 19:06 +0000, Sean Christopherson wrote:
> On Thu, Oct 20, 2022, Maxim Levitsky wrote:
> > On Thu, 2022-10-20 at 18:23 +0300, Maxim Levitsky wrote:
> > > +static void svm_shutdown_intercept_test(void)
> > > +{
> > > +       void* unmapped_address = alloc_vpage();
> > > +
> > > +       /*
> > > +        * Test that shutdown vm exit doesn't crash L0
> > > +        *
> > > +        * Test both native and emulated triple fault
> > > +        * (due to exception merging)
> > > +        */
> > > +
> > > +
> > > +       /*
> > > +        * This will usually cause native SVM_EXIT_SHUTDOWN
> > > +        * (KVM usually doesn't intercept #PF)
> > > +        * */
> > > +       test_set_guest(shutdown_intercept_test_guest);
> > > +       vmcb->save.idtr.base = (u64)unmapped_address;
> > > +       vmcb->control.intercept |= (1ULL << INTERCEPT_SHUTDOWN);
> > > +       svm_vmrun();
> > > +       report (vmcb->control.exit_code == SVM_EXIT_SHUTDOWN, "shutdown (BP->PF->DF->TRIPLE_FAULT) test passed");
> > > +
> > > +       /*
> > > +        * This will usually cause emulated SVM_EXIT_SHUTDOWN
> > > +        * (KVM usually intercepts #UD)
> > > +        */
> > > +       test_set_guest(shutdown_intercept_test_guest2);
> > > +       vmcb_ident(vmcb);
> > > +       vmcb->save.idtr.limit = 0;
> > > +       vmcb->control.intercept |= (1ULL << INTERCEPT_SHUTDOWN);
> > > +       svm_vmrun();
> > > +       report (vmcb->control.exit_code == SVM_EXIT_SHUTDOWN, "shutdown (UD->DF->TRIPLE_FAULT) test passed");
> > > +}
> > > +
> > >  struct svm_test svm_tests[] = {
> > >         { "null", default_supported, default_prepare,
> > >           default_prepare_gif_clear, null_test,
> > > @@ -3382,6 +3432,7 @@ struct svm_test svm_tests[] = {
> > >         TEST(svm_intr_intercept_mix_smi),
> > >         TEST(svm_tsc_scale_test),
> > >         TEST(pause_filter_test),
> > > +       TEST(svm_shutdown_intercept_test),
> > >         { NULL, NULL, NULL, NULL, NULL, NULL, NULL }
> > >  };
> > 
> > Note that on unpatched KVM, this test will cause a kernel panic on the host
> > if run.
> > 
> > I sent a patch today with a fix for this.
> 
> I'm confused.  The KVM patches address a bug where KVM screws up if the SHUTDOWN
> (or INIT) is _not_ intercepted by L1, but the test here does intercept SHUTDOWN.
> Are there more bugs lurking in KVM, or am I missing something?

Yes you don't miss anything - it was a last minute change that I forgot about:

If you let shutdown to not be intercepted, and even if KVM works correclty,
it will still kill qemu, and thus not run other subtests of this test.

The test will still 'pass' silently, something that should be IMHO fixed, the test runner
should check the exit status of qemu or in some other way detect that qemu got shutdown instead
of returning normally.

I decided to make this test in selftests, which also has a bonus of not crashing the host kernel,
since the selftest will come after the fix.

And the above test checks it the other way around which is still a good test IMHO
(I do need to update the commit message though).

Best regards,
	Maxim Levitsky.



> 


