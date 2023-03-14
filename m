Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBE6E6B97E2
	for <lists+kvm@lfdr.de>; Tue, 14 Mar 2023 15:25:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231586AbjCNOZS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Mar 2023 10:25:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231579AbjCNOZA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Mar 2023 10:25:00 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 912001350F
        for <kvm@vger.kernel.org>; Tue, 14 Mar 2023 07:23:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678803795;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Jx4JVPY896aCKLGwQPeuaMvO9tkn3iw26/kjnwKQS2Q=;
        b=iffVkDn74azBhdiyWYSiPWglUEz6/IIXpctcxkLJ4cCgMtiJKw9f03Zs4xV6fU8/X4Nrhn
        0tW1NIE0r2S2QF4ZzpMVX4BiUWqUG2yEZzWYENNzKwKUnw5SouWpidTBQeatW2MsaSxErQ
        XEpXK4PfNi8XE8Gsg6vS4UzoB7Ss1xA=
Received: from mail-ua1-f70.google.com (mail-ua1-f70.google.com
 [209.85.222.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-663-Wgg-85uFNIWqxX9yXjBEEg-1; Tue, 14 Mar 2023 10:23:13 -0400
X-MC-Unique: Wgg-85uFNIWqxX9yXjBEEg-1
Received: by mail-ua1-f70.google.com with SMTP id x12-20020ab036ec000000b0074b980cdc03so3648483uau.21
        for <kvm@vger.kernel.org>; Tue, 14 Mar 2023 07:23:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678803793;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Jx4JVPY896aCKLGwQPeuaMvO9tkn3iw26/kjnwKQS2Q=;
        b=JPGINSY0N9IXZWvnaRHpTUSxWpSL3CJ5xdS4Y/Ua0Rb22D0xxKBIiy7ZXetxyESvt1
         O/4C6DcZEcSc/y7I2uDeRE070u/iaj3IfQMDTHXwPXLSu5lAsjXpfDFTHiSnMIz92SDW
         avtfVppYb1Z0OQLkISfO+cne1kGIqq2zL+5Fxjk7NgARZTCkdZ0cDupW+65P6iiNB103
         1OjSDKcfJHCq/2sZdrCtxFs6o1Vcg1mufmFWPgohw/ud+ym+o9c/6t+DGhMoup7+wA2a
         HBI40A6YpRKysuX3caQiXLRuUCDZ7BFqWSfhokHF0E58rg8jcJM3K/kbBDrQGO4lKu7c
         JRGA==
X-Gm-Message-State: AO0yUKUFUa9LqOwb7BRWOWM66Plve+upjstF8C8e/nKi/uF2/OOHf3T3
        vKtQB3T9jfkTHRMIWfZsmcMfk3zZShR71hC+VGgEFq1D4lB+SO3fpU2gcqISf85DgFiy33SP3nh
        gSlbws0MfZTAE1fgDopdl8CnQBMvS
X-Received: by 2002:a67:e05b:0:b0:425:a606:e3f4 with SMTP id n27-20020a67e05b000000b00425a606e3f4mr1397194vsl.1.1678803792952;
        Tue, 14 Mar 2023 07:23:12 -0700 (PDT)
X-Google-Smtp-Source: AK7set8OP0lYxIV15A1h0gT3msH7c8mvZy2vE2+353B52ysHZ5f4XcuBW6k9OoR5b4o5wpO6YpSwM41YvAF4syER+6c=
X-Received: by 2002:a67:e05b:0:b0:425:a606:e3f4 with SMTP id
 n27-20020a67e05b000000b00425a606e3f4mr1397179vsl.1.1678803792660; Tue, 14 Mar
 2023 07:23:12 -0700 (PDT)
MIME-Version: 1.0
References: <20230131181820.179033-1-bgardon@google.com> <CABgObfaP7P7fk66-EGF-zPEk0H14u3YkM42FRXrEvU=hwFSYgg@mail.gmail.com>
In-Reply-To: <CABgObfaP7P7fk66-EGF-zPEk0H14u3YkM42FRXrEvU=hwFSYgg@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Date:   Tue, 14 Mar 2023 15:23:01 +0100
Message-ID: <CABgObfYAStAC5FgJfGUiJ=BBFtN7drD+NGHLFJY5fP3hQzVOBw@mail.gmail.com>
Subject: Re: [PATCH V5 0/2] selftests: KVM: Add a test for eager page splitting
To:     Ben Gardon <bgardon@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        David Matlack <dmatlack@google.com>,
        Vipin Sharma <vipinsh@google.com>,
        Ricardo Koller <ricarkol@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 14, 2023 at 2:27=E2=80=AFPM Paolo Bonzini <pbonzini@redhat.com>=
 wrote:
> I have finally queued it, but made a small change to allow running it
> with non-hugetlbfs page types.

Oops, it fails on my AMD workstation:

$ tools/testing/selftests/kvm/x86_64/dirty_log_page_splitting_test
Testing guest mode: PA-bits:ANY, VA-bits:48,  4K pages
guest physical test memory: [0x7fc7fe00000, 0x7fcffe00000)
=3D=3D=3D=3D Test Assertion Failure =3D=3D=3D=3D
  x86_64/dirty_log_page_splitting_test.c:195: __a =3D=3D __b
  pid=3D1378203 tid=3D1378203 errno=3D0 - Success
     1    0x0000000000402d02: run_test at dirty_log_page_splitting_test.c:1=
95
     2    0x000000000040367c: for_each_guest_mode at guest_modes.c:100
     3    0x00000000004024df: main at dirty_log_page_splitting_test.c:245
     4    0x00007f4227c3feaf: ?? ??:0
     5    0x00007f4227c3ff5f: ?? ??:0
     6    0x0000000000402594: _start at ??:?
  ASSERT_EQ(stats_populated.pages_4k, stats_repopulated.pages_4k) failed.
    stats_populated.pages_4k is 0x413
    stats_repopulated.pages_4k is 0x412

Haven't debugged it yet.

Paolo

