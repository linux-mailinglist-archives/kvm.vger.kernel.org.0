Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D28011A086
	for <lists+kvm@lfdr.de>; Wed, 11 Dec 2019 02:32:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726522AbfLKBca (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Dec 2019 20:32:30 -0500
Received: from mail-lf1-f43.google.com ([209.85.167.43]:42829 "EHLO
        mail-lf1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726362AbfLKBca (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Dec 2019 20:32:30 -0500
Received: by mail-lf1-f43.google.com with SMTP id y19so15289740lfl.9
        for <kvm@vger.kernel.org>; Tue, 10 Dec 2019 17:32:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=R6rBpO4gs6fGDFRwlWZk9/Eml91zq2U8+fMgTcQjD7o=;
        b=oK7g4009Xdvn6pKiYQQCybPdeYwD6ByeYK/YqmXIWGCBAGW+Tx7yD3/71rs33knMbQ
         EQmUgTqFPtZYnge6lKpnRBXfJoquLI8myNE1pMUfKrjEnt7Lnancs+Ou6wQ2p7vq3i4o
         BdwO9SdQW/SDxUqZbysqJUVSDEmznCCBxK2WU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=R6rBpO4gs6fGDFRwlWZk9/Eml91zq2U8+fMgTcQjD7o=;
        b=O483aPH+Co6SFqV3N8M5Q8jF/tatkTh4C5+2yj07E17hM2NjNXVZD6Lec6Kcr1uo65
         90UJ8qnIF8OADkFebBt3vAMf3tqanF8b4JkvKZ1zZ6m6uOYZutN4EDVJpxxefYPa0n4L
         FtwN/84Fn+F4+uUsR/kDKay2QuRFapKBHHDZg/oXzGJqePSHg3NLaqJfvSHRJtTDTbFB
         9WIi2vm+QavDaTVoAA6sURoxKSV95PNRv8I9gnfuHoCpR89+9Wwbe49OE0nXvCWgWTxT
         3q8jI9Ct8ulb51NhlMHo+8Ns/TvApJQuNETaA9MrqswXclhoBvhR3aNQ1eJptNIFUVD7
         Y/YQ==
X-Gm-Message-State: APjAAAUDgYEgBEZQSP5goB3eX+FbXIV8bw5fmySGj3DlDKLXq6tJ7mZY
        t12OewVQwCrUkXjWYASONO81ew4R57M=
X-Google-Smtp-Source: APXvYqy6ArZaxhabDem4S3QKjBUJxqLrBb3UYCXswgyYIFI/z2XK+1CwHMyssX8m9kb/cfYqxxRTJA==
X-Received: by 2002:a19:c210:: with SMTP id l16mr525532lfc.35.1576027948204;
        Tue, 10 Dec 2019 17:32:28 -0800 (PST)
Received: from mail-lf1-f51.google.com (mail-lf1-f51.google.com. [209.85.167.51])
        by smtp.gmail.com with ESMTPSA id i4sm114918ljg.102.2019.12.10.17.32.27
        for <kvm@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Dec 2019 17:32:27 -0800 (PST)
Received: by mail-lf1-f51.google.com with SMTP id i23so2868858lfo.7
        for <kvm@vger.kernel.org>; Tue, 10 Dec 2019 17:32:27 -0800 (PST)
X-Received: by 2002:a05:6512:1dd:: with SMTP id f29mr523652lfp.106.1576027947197;
 Tue, 10 Dec 2019 17:32:27 -0800 (PST)
MIME-Version: 1.0
From:   Gurchetan Singh <gurchetansingh@chromium.org>
Date:   Tue, 10 Dec 2019 17:32:16 -0800
X-Gmail-Original-Message-ID: <CAAfnVB=8aWSHXHOP8erepbuxOO_-yz04tm8ToA7pLwNAYqA-xQ@mail.gmail.com>
Message-ID: <CAAfnVB=8aWSHXHOP8erepbuxOO_-yz04tm8ToA7pLwNAYqA-xQ@mail.gmail.com>
Subject: How to expose caching policy to a para-virtualized guest?
To:     kvm@vger.kernel.org, maz@kernel.org, pbonzini@redhat.com
Cc:     Gerd Hoffmann <kraxel@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

We're trying to implement Vulkan with virtio-gpu, and that API exposes
the difference between cached and uncached mappings to userspace (i.e,
some older GPUs can't snoop the CPU's caches).

We need to make sure that the guest and host caching attributes are
aligned, or there's a proper API between the virtio driver and device
to ensure coherence.

One issue that needs to be addressed is the caching policy is variable
dependent on the VM configuration and architecture.  For example, on
x86, it looks like a MTRR controls whether the guest caching attribute
predominates[1].  On ARM, it looks like the MMU registers control
whether the guest can override the host attribute, but in general it's
most restrictive attribute that makes a difference[2].  Let me if
that's incorrect.

I'm wondering if there's some standard kernel API to query such
attributes.  For example, something like
arch_does_guest_attribute_matter() or arch_can_guest_flush() would do
the trick.  Without this, we may need to introduce VIRTIO_GPU_F_*
flags set by the host, but that may make the already giant QEMU
command line even bigger.

[1] https://lwn.net/Articles/646712/
[2]  https://events.static.linuxfound.org/sites/events/files/slides/slides_10.pdf
