Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9291577EF60
	for <lists+kvm@lfdr.de>; Thu, 17 Aug 2023 05:06:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347796AbjHQDFr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Aug 2023 23:05:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347845AbjHQDF3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Aug 2023 23:05:29 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 016D02D5E;
        Wed, 16 Aug 2023 20:05:27 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id d2e1a72fcca58-6887b3613e4so1450438b3a.3;
        Wed, 16 Aug 2023 20:05:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1692241526; x=1692846326;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=dCFr8g9hdLn/Gp4gsKaWBuVjf1qv2s3SUk7n6KsdUV8=;
        b=kFvA+/uYbXJhT1Z/qEl3KNHdWxyHpauLcp8EkGsy2iRidsBEdGP+UbU/Dl7lrZ52bx
         ia6JpQkfARQ+4X/Zh4fOkgWLSJZyjhyL1ZpA9YfbdwfO5OeKcegRI8G1Sbzf83eM+RE/
         nbHaCgs7df1gkz9MIep84xRw2QynwQCOyfLEu8yVZo5l+EImf8VXF0rtnkXvC6tfEwue
         wUGE/C6a9eVkBZc7NMGhVtkz88ToEuCnoPONvQw4WDrFG83EStVWt0984n3nLKsIpcr3
         9xTG+5hxAX9RxZWm28TGyUbhSsdmz18tne6Wn5Bqe16FnupFtx5arzQIBw1Bo6LKUJ2g
         3zwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692241526; x=1692846326;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dCFr8g9hdLn/Gp4gsKaWBuVjf1qv2s3SUk7n6KsdUV8=;
        b=GDZhJIOGgUmIb3Zs9HpSAhxXODA8k+cM7zKD7EoUEuppsvjy4OllnOoSnkgi1GRxkG
         /R+23ggcCEc27adm8szo/o8sdv1Z3GzMUtQXqglS5/bfSo2itNvYYffpoRuONF5IjIbY
         2UBYB/dPC84VfH3WzgYZLh36CLdKxKSIsmWW0QD6CI+3s8gLlIutUh9KDrE0ZrHUGFqW
         b2PuIR/xUItse65LsOFm+7sUjKB/3B1DHLyMXkMGYL7cWhMukpty6xQQThzoLyFzp8XA
         olfcTtomGCgY5f3faVFy7zwfc2LTGXAsvZZXTJCIod3aCZpjkRKwgpwfL1J6qzjxB9KG
         BuXw==
X-Gm-Message-State: AOJu0YzbAakyT/Srn8wQrvFa/nTZdRMYWWvd1ejxov2DLPL8ykEKUkxV
        zGF+FaDJCeZtNWOCZvhyKGk=
X-Google-Smtp-Source: AGHT+IETBzR9WoDYjAItJOFnPkvUwNYF7LdkIhh4kX0jJrAh1V7y+63blNn3Wsfx5Xj+E0+SlJCn5g==
X-Received: by 2002:a05:6a00:2443:b0:67e:18c6:d2c6 with SMTP id d3-20020a056a00244300b0067e18c6d2c6mr4459017pfj.5.1692241526286;
        Wed, 16 Aug 2023 20:05:26 -0700 (PDT)
Received: from debian.me ([103.124.138.83])
        by smtp.gmail.com with ESMTPSA id x52-20020a056a000bf400b0068883728c16sm2033018pfu.144.2023.08.16.20.05.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Aug 2023 20:05:25 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
        id 8CFF081A1A74; Thu, 17 Aug 2023 10:05:22 +0700 (WIB)
Date:   Thu, 17 Aug 2023 10:05:22 +0700
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Roman Mamedov <rm+bko@romanrm.net>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Regressions <regressions@lists.linux.dev>,
        Linux KVM <kvm@vger.kernel.org>
Subject: Re: Fwd: kvm: Windows Server 2003 VM fails to work on 6.1.44 (works
 fine on 6.1.43)
Message-ID: <ZN2Ocgp63T0FBuZn@debian.me>
References: <8cc000d5-9445-d6f1-f02e-4629a4a59e0e@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="g0oVnqwyBJRa495L"
Content-Disposition: inline
In-Reply-To: <8cc000d5-9445-d6f1-f02e-4629a4a59e0e@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--g0oVnqwyBJRa495L
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 16, 2023 at 04:29:32PM +0700, Bagas Sanjaya wrote:
> #regzbot introduced: v6.1.43..v6.1.44 https://bugzilla.kernel.org/show_bu=
g.cgi?id=3D217799
> #regzbot title: Windows Server 2003 VM boot hang (only 64MB RAM allocated)

#regzbot fix: https://lore.kernel.org/all/20230811155255.250835-1-seanjc@go=
ogle.com

--=20
An old man doll... just what I always wanted! - Clara

--g0oVnqwyBJRa495L
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZN2OcgAKCRD2uYlJVVFO
oyq8AP9v83lAaDlucHZrPAnwXNC+EsVLyLoms0sKBos74GjFrwD9F11N/ZQ3z2vo
Y2cwCA+IBOnWxlFcH8eQD5c82J0wVAw=
=U376
-----END PGP SIGNATURE-----

--g0oVnqwyBJRa495L--
