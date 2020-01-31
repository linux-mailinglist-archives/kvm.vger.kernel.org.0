Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3975014F3CF
	for <lists+kvm@lfdr.de>; Fri, 31 Jan 2020 22:33:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726239AbgAaVdX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 31 Jan 2020 16:33:23 -0500
Received: from mail-pl1-f195.google.com ([209.85.214.195]:33114 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726109AbgAaVdW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 31 Jan 2020 16:33:22 -0500
Received: by mail-pl1-f195.google.com with SMTP id ay11so3263728plb.0
        for <kvm@vger.kernel.org>; Fri, 31 Jan 2020 13:33:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amacapital-net.20150623.gappssmtp.com; s=20150623;
        h=content-transfer-encoding:from:mime-version:subject:date:message-id
         :references:cc:in-reply-to:to;
        bh=v0cY8r600PZeMMg003zbfyKoArFu5BkniPYK/6FLwIM=;
        b=DB34FYS0GbdREz9MgbfN6GuhgdDTZlKITxD0isHLtPED+4N8iQRLPGGtlunQ0K4Ob+
         NWPbi9TxN1YqENBQKIifltqOpSzi4F+U6/mEVXYtuKxZlh0U/eL6omVSAS9R98bOTolz
         yg0XC8KBPGgb6NZcpOiEpVi/9NALs3R97S4//yxss0Lnb/6RPxcy4a14Hv0R/Crsxhg+
         Fma29ZkKatlSvg/biTbuUo/sPAvkwG8Xm0NHuhbDEZDzRoOXXkYMtshnPho8eF7fyuRy
         r824XGik5cjUwfxU/DsZkZGwtO98sb30s8v3UprW8aUPV/HQud1sPFWrAmQHjlPbnMoP
         J/XA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:content-transfer-encoding:from:mime-version
         :subject:date:message-id:references:cc:in-reply-to:to;
        bh=v0cY8r600PZeMMg003zbfyKoArFu5BkniPYK/6FLwIM=;
        b=RsL1KdvzpMQM57yI49hqnPx6vmKE3Xm9njl7QVQrKSPwnnnjhAXzAo7Zu9d5FPQ8SE
         7LxNrjHSxSHid3chf8SuNBxa6UbZQsH/3rNzGn2HF6gZ0Y9sglnlomxRegwv2iyHJ3wZ
         K2nonTSQkYbq8UsRZ6W7Z7StO4u1CwR5j8xaPSi/IKcaOjv/Qut2YBrQ3fMWIdIeS4Kj
         GvTHHD3wpvE2XxKZmaoLB2fnDUr9TClJVbhYU2pim+DMj7YlHCgCDiHkR9nAB4rIORJC
         YKwBstwB/nVS17kenTzDkfz6EYu62VtRTZ7r5WPcOQbkAT1zTVnantwsse6NUGiZiRfi
         7KsA==
X-Gm-Message-State: APjAAAVfMGKgixihsTELfmC9AVZFUlY9QYUh/YDQsOE+R+gz3KrylB+W
        pkWm2K2hPacCAXhxIlO5Y6SmcjQO2I0=
X-Google-Smtp-Source: APXvYqxUZPWDZetpRBZGKWvETiPTJY3F2228m8xWzfN+cNxLwgMODZHx1RESWs9RO0c/orFHJv/Dkg==
X-Received: by 2002:a17:902:bd90:: with SMTP id q16mr12159154pls.34.1580506402075;
        Fri, 31 Jan 2020 13:33:22 -0800 (PST)
Received: from ?IPv6:2600:1010:b010:9631:69c2:3ecc:ab84:f45c? ([2600:1010:b010:9631:69c2:3ecc:ab84:f45c])
        by smtp.gmail.com with ESMTPSA id m22sm12003610pgn.8.2020.01.31.13.33.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 31 Jan 2020 13:33:21 -0800 (PST)
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
From:   Andy Lutomirski <luto@amacapital.net>
Mime-Version: 1.0 (1.0)
Subject: Re: [PATCH 2/2] KVM: VMX: Extend VMX's #AC handding
Date:   Fri, 31 Jan 2020 13:33:17 -0800
Message-Id: <E1F9CE39-7D61-43E1-B871-6D4BFA4B6D66@amacapital.net>
References: <20200131210424.GG18946@linux.intel.com>
Cc:     Xiaoyao Li <xiaoyao.li@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
In-Reply-To: <20200131210424.GG18946@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
X-Mailer: iPhone Mail (17C54)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> On Jan 31, 2020, at 1:04 PM, Sean Christopherson <sean.j.christopherson@in=
tel.com> wrote:
>=20
> =EF=BB=BFOn Fri, Jan 31, 2020 at 12:57:51PM -0800, Andy Lutomirski wrote:
>>=20
>>>> On Jan 31, 2020, at 12:18 PM, Sean Christopherson <sean.j.christopherso=
n@intel.com> wrote:
>>>=20
>>> This is essentially what I proposed a while back.  KVM would allow enabl=
ing
>>> split-lock #AC in the guest if and only if SMT is disabled or the enable=
 bit
>>> is per-thread, *or* the host is in "warn" mode (can live with split-lock=
 #AC
>>> being randomly disabled/enabled) and userspace has communicated to KVM t=
hat
>>> it is pinning vCPUs.
>>=20
>> How about covering the actual sensible case: host is set to fatal?  In th=
is
>> mode, the guest gets split lock detection whether it wants it or not. How=
 do
>> we communicate this to the guest?
>=20
> KVM doesn't advertise split-lock #AC to the guest and returns -EFAULT to t=
he
> userspace VMM if the guest triggers a split-lock #AC.
>=20
> Effectively the same behavior as any other userspace process, just that KV=
M
> explicitly returns -EFAULT instead of the process getting a SIGBUS.


Which helps how if the guest is actually SLD-aware?

I suppose we could make the argument that, if an SLD-aware guest gets #AC at=
 CPL0, it=E2=80=99s a bug, but it still seems rather nicer to forward the #A=
C to the guest instead of summarily killing it.

ISTM, on an SLD-fatal host with an SLD-aware guest, the host should tell the=
 guest =E2=80=9Chey, you may not do split locks =E2=80=94 SLD is forced on=E2=
=80=9D and the guest should somehow acknowledge it so that it sees the archi=
tectural behavior instead of something we made up.  Hence my suggestion.=
