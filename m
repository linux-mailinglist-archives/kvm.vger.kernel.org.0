Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 930B177AD3
	for <lists+kvm@lfdr.de>; Sat, 27 Jul 2019 19:40:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387979AbfG0RkN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 27 Jul 2019 13:40:13 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:33861 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387665AbfG0RkN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 27 Jul 2019 13:40:13 -0400
Received: by mail-wm1-f65.google.com with SMTP id w9so40092647wmd.1
        for <kvm@vger.kernel.org>; Sat, 27 Jul 2019 10:40:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amacapital-net.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Ep/bHJiwTJubKvCC+mCIkJn0WsJ1FO1eKm4QNltKuYQ=;
        b=ChjuOA3qi8hCRwOL9y99MT+7yo1t/bL0L6Ncsb3uWV71xRrRX6evagsWwnF98DFPzn
         ReISaGFh5kQyGICxbtfmuOI+gkr36ju6f2L+dBfv0rymGAWzj38ODeTccI4tatv/eqZn
         tdOPkjx1kA2nT3LVk/i54jbH4GmtHkszvZxc2kPpBwDfmtsA/g5tA1S5sWz5iIqF+neH
         hDfsbmVPkW8qxlfX819hqG4PGIiF4Us+/RLoov+UGKzyIwkhQv/+0HFbz3vWCFcdQtZK
         iC2FW1CYf/EJPns2g1kwR+89knj+P9DJ5Z36Hk2nEYfDWuasdkc+wHv5+VYihGBvR2E5
         x+tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Ep/bHJiwTJubKvCC+mCIkJn0WsJ1FO1eKm4QNltKuYQ=;
        b=j1pjAbqEoHz8GwCKj0Is4ZuBJzcKqZ7kCkcrz+vcnTU20+ek+R1yooDAX4sjtcF0nA
         I4QawibVLwCoNXwXuvMSsmPLSPopFSMQCinO8tIktLnQhagTVjZ0we7KSr1dTPrq54He
         AhuCLY7/82ttBIiO4BptGiIY2F8lVpis/ibhpjSG02pry2RYdh1Itcf2HzNvJdTH+HNJ
         YEZRolm6a2nTAQoqjnsGCxhVuwKSnGr/RXfiXcx0w4nLbECrc48Y8SbGSZTg+h4QENFr
         S4jfDv3hOsDIbUaY7v5PUvZ/f00lFoQdJ2k0Cw56Vvrr0S55tkQ0ny/+qe373h3W7r0D
         J+cQ==
X-Gm-Message-State: APjAAAXjIfwPkQgtoPwlWfJ/zc5rxC9GpOQoonvUX2NqihUHgDmEyM/A
        Dv+Zt/ILiZjPW/D9JhOeOnYFux43wHkcDu7hYdCKOw==
X-Google-Smtp-Source: APXvYqxTGhXxLIkZBjp9vHFr7vfJZLQQuLojzbsMN1L6Q+kxU1bNPfP5/4CeCgiTLR1EhS6r90+g+fM2xHYaqgFAdyE=
X-Received: by 2002:a7b:c4d2:: with SMTP id g18mr91410809wmk.79.1564248742263;
 Sat, 27 Jul 2019 10:32:22 -0700 (PDT)
MIME-Version: 1.0
References: <20190727055214.9282-1-sean.j.christopherson@intel.com> <20190727055214.9282-22-sean.j.christopherson@intel.com>
In-Reply-To: <20190727055214.9282-22-sean.j.christopherson@intel.com>
From:   Andy Lutomirski <luto@amacapital.net>
Date:   Sat, 27 Jul 2019 10:32:11 -0700
Message-ID: <CALCETrVJ1vMAA-7qtiZ8tg-3qyckSwbzNC2kbbHsojm+W46PWg@mail.gmail.com>
Subject: Re: [RFC PATCH 21/21] KVM: x86: Add capability to grant VM access to
 privileged SGX attribute
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        X86 ML <x86@kernel.org>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Joerg Roedel <joro@8bytes.org>,
        "H. Peter Anvin" <hpa@zytor.com>, kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-sgx@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 26, 2019 at 10:52 PM Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
>
> The SGX subsystem restricts access to a subset of enclave attributes to
> provide additional security for an uncompromised kernel, e.g. to prevent
> malware from using the PROVISIONKEY to ensure its nodes are running
> inside a geniune SGX enclave and/or to obtain a stable fingerprint.
>
> To prevent userspace from circumventing such restrictions by running an
> enclave in a VM, KVM restricts guest access to privileged attributes by
> default.  Add a capability, KVM_CAP_SGX_ATTRIBUTE, that can be used by
> userspace to grant a VM access to a priveleged attribute, with args[0]
> holding a file handle to a valid SGX attribute file corresponding to
> an attribute that is restricted by KVM (currently only PROVISIONKEY).

Looks good to me.  Thanks!

> +can use KVM_CAP_SGX_ATTRIBUTE to grant a VM access to a priveleged attribute.

Spelling.
