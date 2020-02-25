Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4969916B9C7
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2020 07:31:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729036AbgBYGbc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Feb 2020 01:31:32 -0500
Received: from mail-oi1-f195.google.com ([209.85.167.195]:46776 "EHLO
        mail-oi1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725783AbgBYGbc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Feb 2020 01:31:32 -0500
Received: by mail-oi1-f195.google.com with SMTP id a22so11496255oid.13;
        Mon, 24 Feb 2020 22:31:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=yTXnQnJXMwonwysk9ULJEMBbzepXTZX104rAvocoFpg=;
        b=JN2e49PA/MntSGElEaJR40KNMKu61EVbPCCfRPirey3u/q36XyBiIML4HcwELMFDDg
         VM4SoY9ii/Qk/A6yZFSfBfXBw585JQJs8GYg7vnso2Nc31+lSYGesDcTxJYx6mGkxbVp
         DxTaPaPfWs+cnkwY8RYLL7cdhIOUNKR63MJUAowwZcsaygWB0KlXI3U6hv7uhfxNNqsp
         xauMQ/EelcYxriDuFMWuyokrnNkpPjK0sI+IaxY/pDFhOyAabQ6lwylmElqhoe9LOpb5
         vcnK8p3E25F2G36cqLfOlP97b5iBf7mNQYujk/1Ubb0yLX26LOiB8OoVw4Eai4Cx+SvA
         Uxdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=yTXnQnJXMwonwysk9ULJEMBbzepXTZX104rAvocoFpg=;
        b=QazhJztm4AhIQYJ0q0WVH5PzIpKuXyFHH0eKutMRFSKD2TSfur1LICO23R3KwausRg
         bJCp9h0zyASFgPaLHx6SD8GljFn0YNMPDZmXqnBYJXmklXC39QjZmTYh6riayPppt9Nw
         etEaRp9xtI8uh5RD2GnJ0ozcYsg1f1fh29VVBtlb6FTvKV0ikbzhCqzi0YiE26CD69CK
         9ne/b0bo5f2W/wZfnI73645HGx+X8wzU+Z1WiU9RMZwBmrSaB4de4R99N93SbuCZQG9F
         PsfvrpAaRauICUB2cvk7HgT9TmtgAQSvgFs5WXRaFBXN+mD4hB9vCl7VFcS1Nc6DRsmM
         zB9w==
X-Gm-Message-State: APjAAAW8sCf35QyR6w5EBHqf6kV+9vBi68XC633HxDD2sS1yqIuToiak
        wnzXocXQWpOoLuC2+Wh5zeVyPqMRiQdZ+SQZv/M=
X-Google-Smtp-Source: APXvYqz+kVcf0zlMxv5KCUeIPaPVARziQywm6nniqo0yWNTzlrLVJ2zHPdCMRgoeRgoHStm4bjbMXnEQqckua2gLPys=
X-Received: by 2002:aca:44d7:: with SMTP id r206mr2282068oia.33.1582612291759;
 Mon, 24 Feb 2020 22:31:31 -0800 (PST)
MIME-Version: 1.0
References: <07348bb2-c8a5-41d0-afca-26c1056570a5.bangcai.hrg@alibaba-inc.com>
In-Reply-To: <07348bb2-c8a5-41d0-afca-26c1056570a5.bangcai.hrg@alibaba-inc.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Tue, 25 Feb 2020 14:31:20 +0800
Message-ID: <CANRm+CwZq=FbCwRcyO=C7YinLevmMuVVu9auwPqyho3o-4Y-wQ@mail.gmail.com>
Subject: Re: [RFC] Question about async TLB flush and KVM pv tlb improvements
To:     =?UTF-8?B?5L2V5a655YWJKOmCpumHhyk=?= <bangcai.hrg@alibaba-inc.com>
Cc:     namit <namit@vmware.com>, peterz <peterz@infradead.org>,
        pbonzini <pbonzini@redhat.com>,
        "dave.hansen" <dave.hansen@intel.com>, mingo <mingo@redhat.com>,
        tglx <tglx@linutronix.de>, x86 <x86@kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "dave.hansen" <dave.hansen@linux.intel.com>, bp <bp@alien8.de>,
        luto <luto@kernel.org>, kvm <kvm@vger.kernel.org>,
        "yongting.lyt" <yongting.lyt@alibaba-inc.com>,
        =?UTF-8?B?5ZC05ZCv57++KOWQr+e/vik=?= <qixuan.wqx@alibaba-inc.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 25 Feb 2020 at 12:12, =E4=BD=95=E5=AE=B9=E5=85=89(=E9=82=A6=E9=87=
=87) <bangcai.hrg@alibaba-inc.com> wrote:
>
> Hi there,
>
> I saw this async TLB flush patch at https://lore.kernel.org/patchwork/pat=
ch/1082481/ , and I am wondering after one year, do you think if this patch=
 is practical or there are functional flaws?
> From my POV, Nadav's patch seems has no obvious flaw. But I am not famili=
ar about the relationship between CPU's speculation exec and stale TLB, sin=
ce it's usually transparent from programing. In which condition would machi=
ne check occurs? Is there some reference I can learn?
> BTW, I am trying to improve kvm pv tlb flush that if a vCPU is preempted,=
 as initiating CPU is not sending IPI to and waiting for the preempted vCPU=
, when the preempted vCPU is resuming, I want the VMM to inject an interrup=
t, perhaps NMI, to the vCPU and letting vCPU flush TLB instead of flush TLB=
 for the vCPU, in case the vCPU is not in kernel mode or disabled interrupt=
, otherwise stick to VMM flush. Since VMM flush using INVVPID would flush a=
ll TLB of all PCID thus has some negative performance impacting on the pree=
mpted vCPU. So is there same problem as the async TLB flush patch?

PV TLB Shootdown is disabled in dedicated scenario, I believe there
are already heavy tlb misses in overcommit scenarios before this
feature, so flush all TLB associated with one specific VPID will not
worse that much.

    Wanpeng
