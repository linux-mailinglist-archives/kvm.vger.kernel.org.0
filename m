Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D4CDAFC76B
	for <lists+kvm@lfdr.de>; Thu, 14 Nov 2019 14:28:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726473AbfKNN2f (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Nov 2019 08:28:35 -0500
Received: from mail-ot1-f66.google.com ([209.85.210.66]:34439 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726190AbfKNN2f (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Nov 2019 08:28:35 -0500
Received: by mail-ot1-f66.google.com with SMTP id 5so4844843otk.1
        for <kvm@vger.kernel.org>; Thu, 14 Nov 2019 05:28:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Xjr5zKlEt+EbftT5xhsLpgG4fGdHWe+xo3OxBLBvL3Y=;
        b=cGbBhtpgpTYCDDrmVgF2SwAoZ3fYPbdkTucU/MjqUG9j2yNEQZ6xL5N7rhGAACo9uY
         KKq1F4JBoWLdNBGQiUXTZ+yRCXP5jRoTLc3/r2deM45j5osJ7QaJtKZNuS2yPdjmMdMC
         53GpEifuOAs1DD0pucEA0KSPdUdiK/EP4gCqR2wNTzImSP+EbRDLKTaoPL6244mH8JKg
         yYgLOT2U+3NxLy2Trbbs1Bxrq9KQsFn8hCRzJchnxiuCunqpv/6zKSF5mxIvbSZWOROL
         T0bu9qHEXcjwcgjyTL/SRdOkrXCvmDpciiHKWikziNN18Udpo9pOWJ+fcsOJwLar+wdU
         Mh0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Xjr5zKlEt+EbftT5xhsLpgG4fGdHWe+xo3OxBLBvL3Y=;
        b=m6HMbx0z3JMG010qDr2RWZtTisPMEyPTG+4fnfBAyXBgA260+gT3iRLdvhx3dUTdwp
         a+vyxtVp60phycp5gxeaZhXeLXaW3q4oqzoHh9T4xIMVy2ZFUUGTUQiAJGAAM9c7AAir
         U2pT36hlq7yNDQzWWLpz/3bs176RDT0rXpD4QHHiGprukqUsxVjJn1jaLBm9JVICw19P
         nRxJyVpXxotMsvBMO35TYj3mOD5bgWXBlOKuggdRuL3Z3g9YG2ZDRNZ259xH2aGIXENi
         fWFbazZFCeIxS17TfkyMGDid4xOtu9q8P92DS9HFxwHAGQcAft6DYCvCd2HGJtbJ+qJE
         N51Q==
X-Gm-Message-State: APjAAAWxxLNd2wiGZH6b/CA6Y0dHhqmVI9ezLR6pMIhNEc/Ks/UcwKVR
        WqIYBG9gdI+tXkyoCd+yYOQdcx2V/lCglWnQ7cqevg==
X-Google-Smtp-Source: APXvYqx4nhgaDVpUFyQH1EjwIcj3aytFvqeVe52fiR68fN7CPE4E4smXjId0+biIy4CtRU5GM4rxtB2FXvZVvddV7mY=
X-Received: by 2002:a9d:7f12:: with SMTP id j18mr6718381otq.221.1573738114435;
 Thu, 14 Nov 2019 05:28:34 -0800 (PST)
MIME-Version: 1.0
References: <20191113160523.16130-1-maz@kernel.org> <2b846839-ea81-e40c-5106-90776d964e33@de.ibm.com>
 <CAFEAcA8c3ePLXRa_-G0jPgMVVrFHaN1Qn3qRf-WShPXmNXX6Ug@mail.gmail.com>
 <20191114081550.3c6a7a47@why> <5576baca-458e-3206-bdc5-5fb8da00cf6d@de.ibm.com>
 <e781ec19-1a93-c061-9236-46c8a8f698db@redhat.com> <4a9380afe118031c77be53112d73d5d4@www.loen.fr>
In-Reply-To: <4a9380afe118031c77be53112d73d5d4@www.loen.fr>
From:   Peter Maydell <peter.maydell@linaro.org>
Date:   Thu, 14 Nov 2019 13:28:23 +0000
Message-ID: <CAFEAcA92a0t7p+gmHn9d5FU0_hiG2BvGN79uCzjAkFwVd8LqOQ@mail.gmail.com>
Subject: Re: [PATCH] KVM: Forbid /dev/kvm being opened by a compat task when CONFIG_KVM_COMPAT=n
To:     Marc Zyngier <maz@kernel.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        kvm-devel <kvm@vger.kernel.org>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        James Hogan <jhogan@kernel.org>,
        Paul Mackerras <paulus@ozlabs.org>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 14 Nov 2019 at 13:22, Marc Zyngier <maz@kernel.org> wrote:
>  From 34bfc68752253c3da3e59072b137d1a4a85bc005 Mon Sep 17 00:00:00 2001
>  From: Marc Zyngier <maz@kernel.org>
> Date: Thu, 14 Nov 2019 13:17:39 +0000
> Subject: [PATCH] KVM: Add a comment describing the /dev/kvm no_compat
> handling
>
> Add a comment explaining the rational behind having both

"rationale". (Isn't English spelling wonderful?)

> no_compat open and ioctl callbacks to fend off compat tasks.
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>

thanks
-- PMM
