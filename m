Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A0DC2447EC
	for <lists+kvm@lfdr.de>; Thu, 13 Jun 2019 19:03:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729694AbfFMRDE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Jun 2019 13:03:04 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:39854 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389218AbfFMRCy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Jun 2019 13:02:54 -0400
Received: by mail-io1-f68.google.com with SMTP id r185so18520650iod.6
        for <kvm@vger.kernel.org>; Thu, 13 Jun 2019 10:02:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kEdd6ZwEVdi4q8ux1pv01BMnghhMVODdKurwusZLsCQ=;
        b=CceHVuUaraSFi3DR/OSw2iRo9fu6dKdlnUwFmTbugD4LoslVlRGLdq+yRMIhnO2kzP
         wEO1ESs0Xu/04bqfXyd+DzlM3cLiQAT2bNacsUe4FzmlgHsY7gXt8vESjeBiqVtU2RdZ
         zyN0s1n4hOSprjsLCeVOStSn4BMFWQ0A7JfeNt6W9yUQF7tJmTtmSTVjgv3P/poEJR44
         CKSnSoQbU8r/eaIcxbUXvhIV8koThuxFNzKWYMUYFeldWqYxGJ0d5Ck4IQbnZUVP7JSz
         lS8cl6vMoHrPkCT1iwGXFECexMUBPDH7EKxzB8sdSopHtW83H2TaOyU/LZxpF8zXYiYF
         eUMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kEdd6ZwEVdi4q8ux1pv01BMnghhMVODdKurwusZLsCQ=;
        b=MUsmuQq8cWOhlJP9KWoRysdPDEvXK9klrBVXfRXosgFiExypmFkMxy4OkZYHMLZQsM
         jOZtdiG+NlYfQYQaxjntbbAuEpNd0a7PTM4477dL7HkhcaELXOTLv3eWl+1L++9jAupa
         ijlfLtCo8O9jqQ7jE7zH/qHay2SqUAl7g4V7h1vm8d3hEZyOLkprEbuXQiD+woa8GQBl
         NOmwM078EYmGFvFeDdQ7qo7pf96YqwYuXM6XQxvHZr23THvvZaUaRIagr/DjozaQ17Xw
         8GdDLPmiNzyGHswiyw2PiJY1HHLw2zTmtLBtBd193Cg13hEUWwKx/HYBhlRVKG/sIfhW
         HCnQ==
X-Gm-Message-State: APjAAAURqdV6NDM2YNw6scDFVq66tPwwJYl4hS6LkpExyy987xPbCbdc
        payxCanGRACDTAgESsM4QvKz8dm8ZVBAr4B746nF5g==
X-Google-Smtp-Source: APXvYqzmVW0sDStP8cKI/Y3l1+4nns/pvVF+VccRF6+k5dX2K+Kolh38/gTQUAu+HZA5+QODiAv7GezO7zSVX6CKlio=
X-Received: by 2002:a02:ac09:: with SMTP id a9mr998075jao.48.1560445373284;
 Thu, 13 Jun 2019 10:02:53 -0700 (PDT)
MIME-Version: 1.0
References: <20190507153629.3681-1-sean.j.christopherson@intel.com> <20190507153629.3681-2-sean.j.christopherson@intel.com>
In-Reply-To: <20190507153629.3681-2-sean.j.christopherson@intel.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Thu, 13 Jun 2019 10:02:42 -0700
Message-ID: <CALMp9eRb8GC1NH9agiWWwkY5ac4CKxZqzobzmLiV5FiscV_B+A@mail.gmail.com>
Subject: Re: [PATCH 1/7] KVM: nVMX: Intercept VMWRITEs to read-only shadow
 VMCS fields
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        kvm list <kvm@vger.kernel.org>,
        Liran Alon <liran.alon@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 7, 2019 at 8:36 AM Sean Christopherson
<sean.j.christopherson@intel.com> wrote:

> Not intercepting fields tagged read-only also allows for additional
> optimizations, e.g. marking GUEST_{CS,SS}_AR_BYTES as SHADOW_FIELD_RO
> since those fields are rarely written by a VMMs, but read frequently.

Do you have data to support this, or is this just a gut feeling? The
last time I looked at Virtual Box (which was admittedly a long time
ago), it liked to read and write just about every VMCS guest-state
field it could find on every VM-exit.

The decision of which fields to shadow is really something that should
be done dynamically, depending on the behavior of the guest hypervisor
(which may vary depending on the L2 guest it's running!) Making the
decision statically is bound to result in a poor outcome for some
scenarios.

When I measured this several years ago, taking one VM-exit for a
VMREAD or VMWRITE was more expensive than needlessly shadowing it
~35-40 times.
