Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 371AF483996
	for <lists+kvm@lfdr.de>; Tue,  4 Jan 2022 02:01:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231575AbiADBBO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Jan 2022 20:01:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231550AbiADBBM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Jan 2022 20:01:12 -0500
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C04C0C0617A0
        for <kvm@vger.kernel.org>; Mon,  3 Jan 2022 17:01:11 -0800 (PST)
Received: by mail-lf1-x12d.google.com with SMTP id i31so78154862lfv.10
        for <kvm@vger.kernel.org>; Mon, 03 Jan 2022 17:01:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=drummond.us; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=FhCziXSDIVqEHeqdeTNAEnAmaxA2oTV83a7FYCmISUs=;
        b=F3tiUyofNHmKDjVKk2XPN3VpXToJGh87luR1ns6i8fTdNqA4z8KYh9xx+TznQjoZjx
         58TqlIC/Vj4aNPJdMn0Qd4bZbVRnPNzaiJsnWmPeQALXVgD8VLO6jDj+VHazpPTPSB/1
         HWADwSJX1ZZu/dty1WaUP2KxY3Sw8VXiOiuQVgSrT0HZK6iCenP0DqyTmiLJ/HLXpAkt
         XV2/Qm1/GSgSHGlTEcr7ZdTgUQFmUi8gJrn/bzNGljU+2Io9kcqa3WpeXo9FQyxn1hSi
         ZpXEpEI9CKyeqqjCKo8dnjdUhHcpVlmwW0nTMezbw0pCmHnuNbP25JEqrHIUEfMvPFzO
         WX5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=FhCziXSDIVqEHeqdeTNAEnAmaxA2oTV83a7FYCmISUs=;
        b=4r9PwAmmx+noevw/+8CSEaevo+cCJQRgMtJOVg1D69iVRuaI6rt1IVWUtVaeH30mgf
         VDCiBgx/0fCni0PZ4arLvDMPiPJ47Lt0bcT5xt42YGLRiVAHqM5w+0m7xsNppGzWDFJa
         snY2RWSmfStOuzY4TjNR5Ze65L2G1uKBbmWaWf4KQdxwtrGnGgVU2diwsBuo8o8ZiGDH
         feObp9NIYWz4QuKBveYA+VwmVzCGGwKj8H+2MrVQRRBDfAxgN71qy3IAFDDbTY3ossIG
         PgkAE1IMs9QUB9Foe+54XNHrIxE5C2v4kAZjlRnSgmzZDugbKQh5gxN+WB7WnXkoCIlD
         9jfg==
X-Gm-Message-State: AOAM533jnwdfGUpOq1ZM6Ve9GJqVkaBtT0HBtjpwGV/3yPn42kK8h0Rm
        d5p07pLoypADMJkVFt1IJuBH3VB19tHdKSKHbJGGPA==
X-Google-Smtp-Source: ABdhPJwcgc1Ga1+rLCxU1YpJid0/47ry1/i0pez4n8tVA8yyD2kMd606iUiB5mCcPG+LT0NFgOGKtjbLaTH04xucoSo=
X-Received: by 2002:a05:6512:2083:: with SMTP id t3mr41569950lfr.595.1641258069695;
 Mon, 03 Jan 2022 17:01:09 -0800 (PST)
MIME-Version: 1.0
References: <20220103181956.983342-1-walt@drummond.us> <YdNE6UXRT02135Pd@zeniv-ca.linux.org.uk>
In-Reply-To: <YdNE6UXRT02135Pd@zeniv-ca.linux.org.uk>
From:   Walt Drummond <walt@drummond.us>
Date:   Mon, 3 Jan 2022 17:00:58 -0800
Message-ID: <CADCN6nx4VWtR79TBDTENRExjsa=KAGuUpyz06iu2EGmSTPyc+Q@mail.gmail.com>
Subject: Re: [RFC PATCH 0/8] signals: Support more than 64 signals
To:     Al Viro <viro@zeniv.linux.org.uk>
Cc:     aacraid@microsemi.com, anna.schumaker@netapp.com, arnd@arndb.de,
        bsegall@google.com, bp@alien8.de, chuck.lever@oracle.com,
        bristot@redhat.com, dave.hansen@linux.intel.com,
        dwmw2@infradead.org, dietmar.eggemann@arm.com, dinguyen@kernel.org,
        geert@linux-m68k.org, gregkh@linuxfoundation.org, hpa@zytor.com,
        idryomov@gmail.com, mingo@redhat.com, yzaikin@google.com,
        ink@jurassic.park.msu.ru, jejb@linux.ibm.com, jmorris@namei.org,
        bfields@fieldses.org, jlayton@kernel.org, jirislaby@kernel.org,
        john.johansen@canonical.com, juri.lelli@redhat.com,
        keescook@chromium.org, mcgrof@kernel.org,
        martin.petersen@oracle.com, mattst88@gmail.com, mgorman@suse.de,
        oleg@redhat.com, pbonzini@redhat.com, peterz@infradead.org,
        rth@twiddle.net, richard@nod.at, serge@hallyn.com,
        rostedt@goodmis.org, tglx@linutronix.de,
        trond.myklebust@hammerspace.com, vincent.guittot@linaro.org,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        ceph-devel@vger.kernel.org, kvm@vger.kernel.org,
        linux-alpha@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-m68k@vger.kernel.org,
        linux-mtd@lists.infradead.org, linux-nfs@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-security-module@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

I simply wanted SIGINFO and VSTATUS, and that necessitated this. If
the limit of 1024 rt signals is an issue, that's an extremely simple
change to make.



On Mon, Jan 3, 2022 at 10:48 AM Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> On Mon, Jan 03, 2022 at 10:19:48AM -0800, Walt Drummond wrote:
> > This patch set expands the number of signals in Linux beyond the
> > current cap of 64.  It sets a new cap at the somewhat arbitrary limit
> > of 1024 signals, both because it=E2=80=99s what GLibc and MUSL support =
and
> > because many architectures pad sigset_t or ucontext_t in the kernel to
> > this cap.  This limit is not fixed and can be further expanded within
> > reason.
>
> Could you explain the point of the entire exercise?  Why do we need more
> rt signals in the first place?
>
> glibc has quite a bit of utterly pointless future-proofing.  So "they
> allow more" is not a good reason - not without a plausible use-case,
> at least.
