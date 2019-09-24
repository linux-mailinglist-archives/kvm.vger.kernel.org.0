Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D5D47BCF37
	for <lists+kvm@lfdr.de>; Tue, 24 Sep 2019 19:01:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437067AbfIXQxb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Sep 2019 12:53:31 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:33906 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2410893AbfIXQx1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Sep 2019 12:53:27 -0400
Received: by mail-io1-f66.google.com with SMTP id q1so6190718ion.1
        for <kvm@vger.kernel.org>; Tue, 24 Sep 2019 09:53:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=h7Hbjgk6nxZYh+j8UI8QvP5QQ3O/UuIrjfVgqRjhZWY=;
        b=D+tpLGlX5cVrSUoiV7KMXXv1DS4ZiiIhqVdTlsm8RGwH8Y+MYwFm6ckIYNQETajtXL
         0l9Lov9E8+6ZFeDHfZOzkBjBPrcRB9EqhxImTM1j7wGVJkFUZYFO29sHgaF3pp802uzv
         PJsz9abedKdocjWmbwk4fFADIcZc56xUQKhNAJUp4Cm9pVRoCWUE6SejIMFZwyxjJtMs
         cx18xRGQM1wyuD/tV1Q7iSR+Wqy3bEE06BocpnNyprtQJTxsUaj6qiRYo6Ow4CX+MtmM
         QrQHAUtBCC0PjZFP6gealROnA7d+4AwjWCJ5onlx4fGNluZh6f/6uvZ7ssXX7UXQyU39
         MXoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=h7Hbjgk6nxZYh+j8UI8QvP5QQ3O/UuIrjfVgqRjhZWY=;
        b=QyrKvpntCpWK1mAycRzzDALjKkyMbEjX6mfP0r5SyCdhkF5x43euF0A/S7lbo/LOuu
         8yH1TK9PAv5UOAZMpSixj5D0Vy/zuwXxqpsTSWwVZpC/mOGDZvQTe4xGsNGIp3xQDYnv
         weUUAwLkl84hlS2S8IE6GhM976/BD0T3ajoJbwYfCTxE3yQySNkHhKIThQySVZWTEPRB
         OxeMAmtmWsadaLiALoxm3+XjdrN4gxb1EKQ2T2blueKHAKI+ciXBq+9oeyPYOas5opv/
         m45/mSxy6SrS5fE/dk9z8y22dX9WlX2n+G/4Npkz4nkitL/KghM2BaPqhLrijWeoGtsb
         7mFg==
X-Gm-Message-State: APjAAAUDGfhGx5Q3R5+z20pubfUXUtPynYer24sIPGpPrk50b3jPe5U/
        HNgVeXCCmpZLcnQQiDF3Tt/9Ss4tlwkASCmp/NYv8w==
X-Google-Smtp-Source: APXvYqxWnt0XEfaDoM/IIIWbA275LHCyLLIkKD5VJgQFDvMqVxdQxwV96WKzhw0XA1IcjKv0RhQwHoO33fqayzj9RnY=
X-Received: by 2002:a6b:6a01:: with SMTP id x1mr4200106iog.119.1569344006363;
 Tue, 24 Sep 2019 09:53:26 -0700 (PDT)
MIME-Version: 1.0
References: <20190919225917.36641-1-jmattson@google.com> <876a8f61-e84f-c3e1-a9c5-b2a26a083655@redhat.com>
In-Reply-To: <876a8f61-e84f-c3e1-a9c5-b2a26a083655@redhat.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Tue, 24 Sep 2019 09:53:15 -0700
Message-ID: <CALMp9eRy-aaN3JNNZwAecU1Q1vv88ExKe2D=viz=3UJ6JU4vAw@mail.gmail.com>
Subject: Re: [PATCH] kvm: svm: Intercept RDPRU
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm list <kvm@vger.kernel.org>, Drew Schmitt <dasch@google.com>,
        Jacob Xu <jacobhxu@google.com>, Peter Shier <pshier@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 24, 2019 at 7:16 AM Paolo Bonzini <pbonzini@redhat.com> wrote:

> Ugly stuff---Intel did the right thing in making the execution controls
> "enable xxx" (xxx = RDRAND, RDSEED, etc.).

I agree. RDPRU should have been disabled by default, or at least
guarded by a new EFER bit, like MCOMMIT is.
