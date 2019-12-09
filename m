Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D41AE117B85
	for <lists+kvm@lfdr.de>; Tue, 10 Dec 2019 00:34:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727324AbfLIXe5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Dec 2019 18:34:57 -0500
Received: from mail-io1-f68.google.com ([209.85.166.68]:37237 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727213AbfLIXe5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Dec 2019 18:34:57 -0500
Received: by mail-io1-f68.google.com with SMTP id k24so16775265ioc.4
        for <kvm@vger.kernel.org>; Mon, 09 Dec 2019 15:34:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PVQUouAy816y0uyHhvwcxK/w9XaQZWB3ZWINy3UHLgA=;
        b=Q7abo8oeBVcyqwiIn3KDEKKBMKQEdKqubN+bMfmWtcwRrNrbmJZ1xbVjOpDr3wvh34
         BlAX+ctpZQK89rLmQF0ByuiTV+99O9TwtDQlBrSeNZeZV4UyvuZo2zdUqz2yoKIcse8o
         RP7jKNd+Ay1HrqZjlae5KLhzCe0bIqhXIfqOmEu6r4/RuIu1a39a/Efu9C7kUQZocEO/
         LFsV3qX+JHZFiZuMOtc1XMlilVapJGIinqOvqqXW9aPmriW0E4nb2Erg8YG8ADr5F8Sq
         I/rSX7h+IS+o7dI2j6l63Jlg0Cww6lwcBq6i3iRtGlKGDzuEl9eeyUmu//MYaANklfIy
         imwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PVQUouAy816y0uyHhvwcxK/w9XaQZWB3ZWINy3UHLgA=;
        b=o38uJO7RZe87qCUgcWgSuwwF2yJQyjQAhW+AqZguxrTwFiSvDzNBq5wwL9IgSZpMJv
         ferFiTkxLUZ7eU5M/JmZaQ3Xj4jNEKDO4N6URZ+nag14V2pHkwmvKlrwPwJeNeBj3R/P
         UavwFfdMu0m011K9UTyi5DSA4GMBteOuD98IPh6eUuIgGLDpqEdwJCxkqDU8OJPbMhnH
         DGfxQUCWvW/xfHojxzxp6ay4rjx0TCMFgPKfQrLG+bwaIdxazAkfFSsduHIgOlboSG++
         fk0ObDBwfgajEJQ+RvCT+BBWI9E4N/O4b3EipW1oFrZoSIO4hYHHrOF/RwpIQGBwx2YH
         JdzA==
X-Gm-Message-State: APjAAAUpWWS9tjRXF+bsq8LaI+mfDjqus6p5XOAm2m3Bqd6LTPDOCEPq
        B/e2H0xALUoFE8SeUrsPq2PgAvSp1Y9NRphKoRNU7Q==
X-Google-Smtp-Source: APXvYqzdYedlVulEWln7b7++OZJFZud1YWY+QFIWZb+8SXo+Sap0nsiAIhgJZQQGqYH2yWhNQKFtqn7OgJqohyzZ/K0=
X-Received: by 2002:a5e:924c:: with SMTP id z12mr23275698iop.296.1575934496001;
 Mon, 09 Dec 2019 15:34:56 -0800 (PST)
MIME-Version: 1.0
References: <20191204214027.85958-1-jmattson@google.com> <b9067562-bbba-7904-84f0-593f90577fca@redhat.com>
 <CALMp9eRbiKnH15NBFk0hrh8udcqZvu6RHm0Nrfh4TikQ3xF6OA@mail.gmail.com>
 <CALMp9eTyhRwqsriLGg1xoO2sOPkgnKK1hV1U3C733xCjW7+VCA@mail.gmail.com> <f20972b7-ea45-6177-afa6-f980c9bd6d0f@redhat.com>
In-Reply-To: <f20972b7-ea45-6177-afa6-f980c9bd6d0f@redhat.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Mon, 9 Dec 2019 15:34:44 -0800
Message-ID: <CALMp9eRag2YFfK-2y-e12NdP+EE068nC+Sv_=BVtBdPXV-FE7Q@mail.gmail.com>
Subject: Re: [PATCH] kvm: nVMX: VMWRITE checks VMCS-link pointer before VMCS field
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm list <kvm@vger.kernel.org>, Liran Alon <liran.alon@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Dec 9, 2019 at 8:12 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 05/12/19 22:30, Jim Mattson wrote:
> >> I'll put one together, along with a test that shows the current
> >> priority inversion between read-only and unsupported VMCS fields.
> > I can't figure out how to clear IA32_VMX_MISC[bit 29] in qemu, so I'm
> > going to add the test to tools/testing/selftests/kvm instead.
> >
>
> With the next version of QEMU it will be "-cpu
> host,-vmx-vmwrite-vmexit-fields".
>
> Paolo

Or, presumably, -cpu Westmere?
