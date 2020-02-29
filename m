Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 679681748B0
	for <lists+kvm@lfdr.de>; Sat, 29 Feb 2020 19:33:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727559AbgB2Sd3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 29 Feb 2020 13:33:29 -0500
Received: from mail-lj1-f193.google.com ([209.85.208.193]:34725 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727540AbgB2Sd1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 29 Feb 2020 13:33:27 -0500
Received: by mail-lj1-f193.google.com with SMTP id x7so7078195ljc.1
        for <kvm@vger.kernel.org>; Sat, 29 Feb 2020 10:33:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=J0QUgzZ4WkYGkcRzl+slh7S/9xKhHLAbeIDFRLeX4rY=;
        b=Pv97Pxv7b0wU24jRqR7G5YZY9n7APjj/ALQ0caAR8Id0ktGWCsHqyGFZSeA/LEdfFf
         iDCHTWuZ1WbLL9I4uSLaRgXcjiZA7cDOhmAHiAzEeiOT8S7hJjAWmDSCXEZTtxP994x2
         OPkkRsAgjae6w3YWRKvH+CeSbsJyCde7zx9/FR5qbYJ4R6rFyjVxNewl8BAXWJ3pJLJ8
         rQtFdml4SigigKM/eAG2tEbVglD32SraR7GlDPKd31DE42SD9L25jP4a1Lsshl2xuRYP
         vKD9joU/IWNwS19M6od5S3XeeydZiNxrxDQKWrc0CMs5QPPY3H9ZA4nt64xZiT2WoxHJ
         og6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=J0QUgzZ4WkYGkcRzl+slh7S/9xKhHLAbeIDFRLeX4rY=;
        b=sX8/0rEmTLD9NKxAX9iIKyj5P+nsPdhrufErMwV8gw4y/Dvbdx7qMcObM8CE2cvo3T
         gRjWEuiBQedPuloOsO7a19aC8iYYXKomQet4Zn+rj6IxKmu/jlZ7nMfRi222gr2il/oz
         6La7NoFp1H+hknitwSPJEtngHAt4pWt7H2Yu1S86lF7wbGfHOuArjrCJZx6V8k1eiEwc
         OtaYoQOQD39OSt/ah1DdXt3/GPCvLSI3r/3yw9ADQwEp86nR6STismBMSxDjO5KV07ff
         b9sNjJ57cv9dRB+RrH5GA/5jSFLuUIl4s+NCqILWL7B8h65fjvThTuNobQF7VNJ8pGTr
         7VuQ==
X-Gm-Message-State: ANhLgQ3DvDFfseZTv6DpbIGYRMrmkXCmvhvYFGPH5FXtrBARpFtK+dgh
        kHidzQ06+K9xLWARxhFDDHAvqUswWtxXaZYgfumUaqtA
X-Google-Smtp-Source: ADFU+vtSviI3qlY7iSQKY0tYuP5O6rDtodZyvgxGWul1aApy5++Pdps2sONbzNDv2OmtBRGkjQOImS5ZTyGBxCEfcHU=
X-Received: by 2002:a2e:3608:: with SMTP id d8mr6575052lja.152.1583001203709;
 Sat, 29 Feb 2020 10:33:23 -0800 (PST)
MIME-Version: 1.0
References: <1582570596-45387-1-git-send-email-pbonzini@redhat.com>
 <1582570596-45387-2-git-send-email-pbonzini@redhat.com> <41d80479-7dbc-d912-ff0e-acd48746de0f@web.de>
In-Reply-To: <41d80479-7dbc-d912-ff0e-acd48746de0f@web.de>
From:   Oliver Upton <oupton@google.com>
Date:   Sat, 29 Feb 2020 10:33:12 -0800
Message-ID: <CAOQ_QshE7SMX2cO7H+21Fkdpg53oE2D3xrHPJHR_MCfH4r9QCQ@mail.gmail.com>
Subject: Re: [FYI PATCH 1/3] KVM: nVMX: Don't emulate instructions in guest mode
To:     Jan Kiszka <jan.kiszka@web.de>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>, stable@vger.kernel.org,
        Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Jan,

On Sat, Feb 29, 2020 at 10:00 AM Jan Kiszka <jan.kiszka@web.de> wrote:
> Is this expected to cause regressions on less common workloads?
> Jailhouse as L1 now fails when Linux as L2 tries to boot a CPU: L2-Linux
> gets a triple fault on load_current_idt() in start_secondary(). Only
> bisected so far, didn't debug further.

I'm guessing that Jailhouse doesn't use 'descriptor table exiting', so
when KVM gets the corresponding exit from L2 the emulation burden is
on L0. We now refuse the emulation, which kicks a #UD back to L2. I
can get a patch out quickly to address this case (like the PIO exiting
one that came in this series) but the eventual solution is to map
emulator intercept checks into VM-exits + call into the
nested_vmx_exit_reflected() plumbing.

--
Thanks,
Oliver
