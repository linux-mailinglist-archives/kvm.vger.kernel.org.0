Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6BBAC6B193E
	for <lists+kvm@lfdr.de>; Thu,  9 Mar 2023 03:37:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229735AbjCIChw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Mar 2023 21:37:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229542AbjCIChu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Mar 2023 21:37:50 -0500
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DF77898FA;
        Wed,  8 Mar 2023 18:37:49 -0800 (PST)
Received: by mail-pj1-x1043.google.com with SMTP id ce8-20020a17090aff0800b0023a61cff2c6so5033192pjb.0;
        Wed, 08 Mar 2023 18:37:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678329469;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=XwvQHTUf/GUAbiJepj3MWRNjatym77APweYxMUICMk4=;
        b=opWhz/J0dQN3N8iPg7FE97lxF7dJfJahgQlMgnH2Ee74MILqXGgsztaE6qo1dm7zpQ
         heA5GN6FAkH9DyNbD2a97mPFxJEFCcijuqIvequ3CswtfGROoscWw3zxijcbuPPaHBGF
         fzstuLc9I6P3hYxFo+IUPStMVlgh8B39aZKERRR/6zgjb78UWKMo0gjPxLXkrD8Gjd8E
         mkBf85MMMHp+cSaw43k9gHYeump0F1MwXN6e/VXUvodXL6BYJzKB4Iodb26GQ37lZhAu
         HFjeOlYiFK18QG/PNG2wOugUxZImUv+wkei3KC86jLUmmHPgsYMa9hFv2wraJEv5bPq8
         qhiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678329469;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XwvQHTUf/GUAbiJepj3MWRNjatym77APweYxMUICMk4=;
        b=SRyOVVYyn6RiZVkBEcYJTFy4/jxaB+Dpi6g0bvg2OB9vcoF4EZd22DHzeSr8hVy8BJ
         PjVydJgVd6odjPWtGh6hBgMuJYiWU64kxQwRl2WET83fvvFjpD8J8mmvrgf7XoBf0qZ5
         9NXsJROq19TNCaaiA+CF/3gP8fV6T30oCqKCIVCEdpNeLBz1bYlUD4OOI9I+E2OMnjls
         bdQ6bej/uFuOLc4kXrg4MmO7pCxvqSiflIzw1vu3RZWCg8Fm8gpaMtVBz2cJwWgERCr/
         RaGH7jW1bjeOhYkAAlQ/N0N98yUT6ZuQq11/Q/gwxKfBXURxnto/RmSC338MccGsvJpA
         luhQ==
X-Gm-Message-State: AO0yUKV0g6lW7DMmJCvD9eFCzLl2mmj7yc5Vy9rUvJkW9ShzOg1eiQB1
        T1K7/tV+lSXkXkBq4lztgzQ=
X-Google-Smtp-Source: AK7set9PZgLdGeH2TqljoOkNS0TwHST28x6OaHGTd8cpFi9+IQ8oxYy9Dmz5sta5QzZvMRyEGyAPJg==
X-Received: by 2002:a17:90a:56:b0:230:bca9:2f7c with SMTP id 22-20020a17090a005600b00230bca92f7cmr24296263pjb.2.1678329468670;
        Wed, 08 Mar 2023 18:37:48 -0800 (PST)
Received: from debian.me (subs02-180-214-232-87.three.co.id. [180.214.232.87])
        by smtp.gmail.com with ESMTPSA id v7-20020a63f847000000b00502f20aa4desm9872282pgj.70.2023.03.08.18.37.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Mar 2023 18:37:48 -0800 (PST)
Received: by debian.me (Postfix, from userid 1000)
        id 5DD001065B9; Thu,  9 Mar 2023 09:37:45 +0700 (WIB)
Date:   Thu, 9 Mar 2023 09:37:45 +0700
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Sagi Shahar <sagis@google.com>,
        Erdem Aktas <erdemaktas@google.com>,
        Peter Shier <pshier@google.com>,
        Anish Ghulati <aghulati@google.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        James Houghton <jthoughton@google.com>,
        Anish Moorthy <amoorthy@google.com>,
        Ben Gardon <bgardon@google.com>,
        David Matlack <dmatlack@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Aaron Lewis <aaronlewis@google.com>,
        Ashish Kalra <ashish.kalra@amd.com>,
        Babu Moger <babu.moger@amd.com>, Chao Gao <chao.gao@intel.com>,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Chenyi Qiang <chenyi.qiang@intel.com>,
        David Woodhouse <dwmw@amazon.co.uk>,
        Emanuele Giuseppe Esposito <eesposit@redhat.com>,
        Gavin Shan <gshan@redhat.com>,
        Guang Zeng <guang.zeng@intel.com>,
        Hou Wenlong <houwenlong.hwl@antgroup.com>,
        Jiaxi Chen <jiaxi.chen@linux.intel.com>,
        Jim Mattson <jmattson@google.com>,
        Jing Liu <jing2.liu@intel.com>,
        Junaid Shahid <junaids@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Leonardo Bras <leobras@redhat.com>,
        Like Xu <like.xu.linux@gmail.com>,
        Li RongQing <lirongqing@baidu.com>,
        "Maciej S . Szmigiero" <maciej.szmigiero@oracle.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Michael Roth <michael.roth@amd.com>,
        Michal Luczaj <mhal@rbox.co>,
        Mingwei Zhang <mizhang@google.com>,
        Nikunj A Dadhania <nikunj@amd.com>,
        Paul Durrant <pdurrant@amazon.com>,
        Peng Hao <flyingpenghao@gmail.com>,
        Peter Gonda <pgonda@google.com>, Peter Xu <peterx@redhat.com>,
        Robert Hoo <robert.hu@linux.intel.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Vipin Sharma <vipinsh@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Wei Wang <wei.w.wang@intel.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>,
        Yu Zhang <yu.c.zhang@linux.intel.com>,
        Zhenzhong Duan <zhenzhong.duan@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/2] Documentation/process: Add a maintainer handbook
 for KVM x86
Message-ID: <ZAlGeYAmvhPmVmGe@debian.me>
References: <20230309010336.519123-1-seanjc@google.com>
 <20230309010336.519123-3-seanjc@google.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="NDWV0Qdh3JqbrY46"
Content-Disposition: inline
In-Reply-To: <20230309010336.519123-3-seanjc@google.com>
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--NDWV0Qdh3JqbrY46
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 08, 2023 at 05:03:36PM -0800, Sean Christopherson wrote:
> +As a general guideline, use ``kvm-x86/next`` even if a patch/series touc=
hes
> +multiple architectures, i.e. isn't strictly scoped to x86.  Using any of=
 the
> +branches from the main KVM tree is usually a less good option as they li=
kely
> +won't have many, if any, changes for the next release, i.e. using the ma=
in KVM
> +tree as a base is more likely to yield conflicts.  And if there are non-=
trivial
> +conflicts with multiple architectures, coordination between maintainers =
will be
> +required no matter what base is used.  Note, this is far from a hard rul=
e, i.e.
> +use a different base for multi-arch series if that makes the most sense.

That means patches that primarily kvm ARM changes should be based on
kvm-x86/next, right?

> +If a patch touches multiple topics, traverse up the conceptual tree to f=
ind the
> +first common parent (which is often simply ``x86``).  When in doubt,
> +``git log path/to/file`` should provide a reasonable hint.

What do you mean by conceptual tree? Is it Patch subject prefix?

> +KVM selftests that are associated with KVM changes, e.g. regression test=
s for
> +bug fixes, should be posted along with the KVM changes as a single serie=
s.  The
> +standard kernel rules for bisection apply, i.e. KVM changes that result =
in test
> +failures should be ordered after the selftests updates, and vice versa, =
new
> +tests that fail due to KVM bugs should be ordered after the KVM fixes.

Did you mean that in a patch series, selftest patches are placed after
their corresponding KVM changes?

Thanks.

--=20
An old man doll... just what I always wanted! - Clara

--NDWV0Qdh3JqbrY46
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZAlGdAAKCRD2uYlJVVFO
o+TdAP9DJ67tjIQE98q87j5y5QSunga8EATx+tybmWc+J/G3VQD/S5M66oNorefy
PI6e/pSeetKmqTEqlxuLlylfAHb0Vgo=
=yhsP
-----END PGP SIGNATURE-----

--NDWV0Qdh3JqbrY46--
