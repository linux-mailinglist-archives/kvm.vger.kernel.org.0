Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 50B8D1A2B18
	for <lists+kvm@lfdr.de>; Wed,  8 Apr 2020 23:29:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730393AbgDHV3V (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Apr 2020 17:29:21 -0400
Received: from mail-qv1-f67.google.com ([209.85.219.67]:44641 "EHLO
        mail-qv1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729222AbgDHV3U (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Apr 2020 17:29:20 -0400
Received: by mail-qv1-f67.google.com with SMTP id ef12so4470920qvb.11
        for <kvm@vger.kernel.org>; Wed, 08 Apr 2020 14:29:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=lca.pw; s=google;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=SVDtsGi6neGFRwikvRHYLrFbo8bPwU6BhE0B4MocRjo=;
        b=BWwwyhWdP4bCAjyoQRTv8OV8mtlXVPHwPlIm8qddLZj7iC674KnBH0wZ5gmU6DqS70
         C1/zjPys7SA2QSBdBBh/Vp7z8tP4MoDCZ3J7yPaCEb3aWrDPLZrEzEc/s5uDb6B3B/Zz
         Q/D2iUPkb1UdcJAn2P997ms7im6hGVN1AKeVtc8UTksahOiOgwZP7W4x2aRAkYxmqdzU
         iRMjGNH23UhxVno00at7cV4XSlx7ataddhOqFfxmG3KosI9iQ69ciGaSMtVokdO2MFwz
         mouuM4fw0+U2UEJVYG186lPlYQdy+/QTmGdmwSkRbzlnh2r3DVGyLygwJLFIOmeGB5Hs
         PMWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=SVDtsGi6neGFRwikvRHYLrFbo8bPwU6BhE0B4MocRjo=;
        b=ZEVs3cU/Da6nnTdgD0Fyuqk+Mh5RqxNzdEFdRPwrMbz3KlArH59EXn7lhCmLn24fZX
         djtBEJTvyeZ0Poee9H1cUMs33a4RBDZZxOClgbueTET0NzzKVsBKVWJULRetj53AWdhN
         a+W2t+y+cVLovvErOgS0vv1PcU0qhI7GhxrWq7pVIMurmUyBjBOTFxw8P+LueVxDGR7A
         Jf20jA3mr8qX3pLieXDvPNnmLOm0G2ciwwHo6vuv5Wb44beIWpFZXYKBaT7u5BLnUFxh
         s3YvZ9mHFbWKhS7/qNaIOju/HXYMlnAI/RhkuBbbsmqDu2xSEMzwI6l/5MdSEknFIYUn
         FIOA==
X-Gm-Message-State: AGi0PuYqsfxTLCxqWM1EidwTyy0KCbHvMlXqjaCYveehpVjTaD5Wrq0H
        ogowsmPj2kgEQrwB6DUhhRUi1g==
X-Google-Smtp-Source: APiQypIAPF83IDbnxE4npOa8BA/v00NSOs87AvIVV9hoWH5sYbQDJUSaLOrsAy9lYhzUtsirbdBiqw==
X-Received: by 2002:a05:6214:b21:: with SMTP id w1mr9649854qvj.69.1586381359791;
        Wed, 08 Apr 2020 14:29:19 -0700 (PDT)
Received: from [192.168.1.153] (pool-71-184-117-43.bstnma.fios.verizon.net. [71.184.117.43])
        by smtp.gmail.com with ESMTPSA id i13sm12975162qtj.37.2020.04.08.14.29.18
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 08 Apr 2020 14:29:18 -0700 (PDT)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.80.23.2.2\))
Subject: Re: KCSAN + KVM = host reset
From:   Qian Cai <cai@lca.pw>
In-Reply-To: <fb39d3d2-063e-b828-af1c-01f91d9be31c@redhat.com>
Date:   Wed, 8 Apr 2020 17:29:18 -0400
Cc:     Elver Marco <elver@google.com>,
        "paul E. McKenney" <paulmck@kernel.org>,
        kasan-dev <kasan-dev@googlegroups.com>,
        LKML <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <017E692B-4791-46AD-B9ED-25B887ECB56B@lca.pw>
References: <E180B225-BF1E-4153-B399-1DBF8C577A82@lca.pw>
 <fb39d3d2-063e-b828-af1c-01f91d9be31c@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
X-Mailer: Apple Mail (2.3608.80.23.2.2)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> On Apr 8, 2020, at 5:25 PM, Paolo Bonzini <pbonzini@redhat.com> wrote:
>=20
> On 08/04/20 22:59, Qian Cai wrote:
>> Running a simple thing on this AMD host would trigger a reset right =
away.
>> Unselect KCSAN kconfig makes everything work fine (the host would =
also
>> reset If only "echo off > /sys/kernel/debug/kcsan=E2=80=9D before =
running qemu-kvm).
>=20
> Is this a regression or something you've just started to play with?  =
(If
> anything, the assembly language conversion of the AMD world switch =
that
> is in linux-next could have reduced the likelihood of such a failure,
> not increased it).

I don=E2=80=99t remember I had tried this combination before, so don=E2=80=
=99t know if it is a
regression or not.=
