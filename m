Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0DD0FF5D53
	for <lists+kvm@lfdr.de>; Sat,  9 Nov 2019 05:19:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726275AbfKIETV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Nov 2019 23:19:21 -0500
Received: from mail-oi1-f195.google.com ([209.85.167.195]:37774 "EHLO
        mail-oi1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726019AbfKIETV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Nov 2019 23:19:21 -0500
Received: by mail-oi1-f195.google.com with SMTP id y194so7160994oie.4;
        Fri, 08 Nov 2019 20:19:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=aPjQoy7oZ5u0GHXcjqq0pDVFggOBodtLQIdVNE5FTLo=;
        b=m1OFAk12u8S+O/mQg6ziJeZ9S8MfqfP7uF33MqpUJldGMvU43ilCcRhNRjND8B63tT
         nqv918AJFTyljnjjSa0u+veHg8TUFW7F/71LusVIJTDiDjd41hK9E/ebqQBy3EU0Wid6
         9WIz2g14wFhChMRvySokSHtXuhR5QVa7j5CUw8f3HJq0xzJUb5t2t7yBegf+u6R9eNcJ
         Yg6Na1/g0DGk5R97lt7jaHyxNSsleOtQfTUcXZOUQncralu80HkGQH/Z3YP3DYgeqIvb
         kASBiSUZn07aDap4ax/TnzUsuk5oj94qPCnC2MaHIxiXTfx47TrVvlAciSlHn4HVnAYy
         N2pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=aPjQoy7oZ5u0GHXcjqq0pDVFggOBodtLQIdVNE5FTLo=;
        b=uFVF89ovS2VWzdWBmEQvu4gaQMKU/Q3I0HOwnVLQLqn0j7CbwvInscYSWTQJ4wZcsb
         qwy77AeMiPaa8W7UFpX0g/qhQVWEu681XIe6CtYvMHwBUCMa/MzgSMDtRjkcVlJ51IPi
         2GXvSQN8m7eee5C9XWumXdpJnkJwvpO2V1d2a/B2awmdgCY6XnJe8sSa/C4EnygPWVGT
         ftrIjAKzzkeMjeETRQhbKUR+qxBvxJNDeSCZGNPFGphP+/JcjisAb/Ni6VWRRFgIP7Bn
         RwKM2nMKUMUWJ8/BeOiggVm+KndHnEgWwC9Kghep4HU+hIRBge1CT/zMyiza3gzhC/Pj
         Mj9g==
X-Gm-Message-State: APjAAAWWN0X3pMlFmufDXvPOvHsoQ5mWHCGDe9Rc1Rk5mkhzBfywYc7y
        rZxJcy5+8J7x8MTYl+EPyQalJQvt2eHf5GEj/Oc=
X-Google-Smtp-Source: APXvYqzAGwKIcMRqRuKKEDKDDvWilS7oF8XklhKFxaceePq/ye3gdBkZu6ZVTlYYhbUWLto5H/qOAB+pAf5xUVjA3Rw=
X-Received: by 2002:aca:5015:: with SMTP id e21mr13298346oib.174.1573273160438;
 Fri, 08 Nov 2019 20:19:20 -0800 (PST)
MIME-Version: 1.0
References: <20191106082636.GB31923@mwanda> <8f7e33e9-9ae0-4f56-3bb6-b9f3db807d38@de.ibm.com>
 <7eddf725-e034-d65d-3fb1-2babcfaa812d@redhat.com>
In-Reply-To: <7eddf725-e034-d65d-3fb1-2babcfaa812d@redhat.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Sat, 9 Nov 2019 12:19:14 +0800
Message-ID: <CANRm+Cy4xpmQfv8VwA__FQzex+T0d44FKiMQ4RT9rZ4zex+Bjw@mail.gmail.com>
Subject: Re: [PATCH] kvm: Fix NULL dereference doing kvm_create_vm()
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Jim Mattson <jmattson@google.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Junaid Shahid <junaids@google.com>, kvm <kvm@vger.kernel.org>,
        kernel-janitors@vger.kernel.org, Wanpeng Li <wanpengli@tencent.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 6 Nov 2019 at 17:46, Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 06/11/19 09:30, Christian Borntraeger wrote:
> > The same patch was already sent by Wanpeng Li.
> >
> > See
> > https://lore.kernel.org/lkml/1572848879-21011-1-git-send-email-wanpengli@tencent.com/
>
> I'm also going to send a somewhat different version today (hopefully).
> Stay tuned...

You can move forward if patches there.

    Wanpeng
