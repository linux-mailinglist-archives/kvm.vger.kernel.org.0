Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 30BF515B924
	for <lists+kvm@lfdr.de>; Thu, 13 Feb 2020 06:42:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729383AbgBMFmQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Feb 2020 00:42:16 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:44997 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725773AbgBMFmQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Feb 2020 00:42:16 -0500
Received: by mail-wr1-f68.google.com with SMTP id m16so5076797wrx.11
        for <kvm@vger.kernel.org>; Wed, 12 Feb 2020 21:42:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amacapital-net.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KrVdZxUS3EdrVwf2LulQeNvZSOGZj8UErtKTW8hDsp4=;
        b=w1uRGrofq8Crx4GZdwfV4wkquRC4twWMACVsFhy2Vd8PPoWrSLPsxcRraKzCuVKIas
         Yg8oy6NL12nIc2ofcDMw5Tajqly5YvuLoiTrfpyyGDjxQPqciZAWZfOsY7hNhULFrF6L
         K4fsc3JRjcrporH+RWc5Q/v4uWanuptrZUE2GDS9EZlDKH3N0XZmdHtexNAwuKl2vtXm
         npgUYKosKJR+H4OijQ/5Yrn5Uo2wtxngqiaxUjSL+WiGbkltgks4pFgKLX2UEeQHwgvJ
         H35ywMcxhefmRoAbu3nSPcAQcbfd6CZgIDR6yj6SV0FARWPbdYa3bz9XBLfLsZi3+Gfd
         FIjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KrVdZxUS3EdrVwf2LulQeNvZSOGZj8UErtKTW8hDsp4=;
        b=f9v98tv8ACtyEU/o/mVqXvIsJhDCSKeF+NdoHwUMRjpZD6fibyrxxpTfnvIKiakmSM
         +GN3BWfg7z205k+v+E3htDbXa86BSz3w9yDQNm7xhi2RWpW4ekpPBZdy8g+1WJpZNX4L
         9hdzlzDNJ4yYbq3mDfa8Iomfx/WoURmsD61zPYv1JYzMK+uYSq61OXlCg27OjqQFjckK
         9ZxZhf931Kdw5gRq8oXxkNHbGFDiWztmI3VY2IqN0SHi3/1ePXtbiETVRfHc7OcqdLKs
         cuhp2meHwZ5zRYZHuefFfR03hwmHFPiG6MNIa2RWpTyzGstTBbmS6g1QpVbDMpI2iEN9
         078w==
X-Gm-Message-State: APjAAAUkatuEbyfgANpg/ja7grwwL0oGGPjWb17t4NkvhLC5piEe0vTt
        h9isY6IyXlDZSBu0gp5jQhjf9gc0FJeiJyQXjlAEoA==
X-Google-Smtp-Source: APXvYqzbLibnTsVhaOasUfqj4QQmDz+9rvU/9cSEEzpgU+tO3apNBRAozS/osrvVGr+j/63o9K7WjhWWHKgRCSrzUj0=
X-Received: by 2002:adf:ea85:: with SMTP id s5mr19169000wrm.75.1581572533390;
 Wed, 12 Feb 2020 21:42:13 -0800 (PST)
MIME-Version: 1.0
References: <cover.1581555616.git.ashish.kalra@amd.com> <a22c5b534fa035b23e549669fd5ac617b6031158.1581555616.git.ashish.kalra@amd.com>
In-Reply-To: <a22c5b534fa035b23e549669fd5ac617b6031158.1581555616.git.ashish.kalra@amd.com>
From:   Andy Lutomirski <luto@amacapital.net>
Date:   Wed, 12 Feb 2020 21:42:02 -0800
Message-ID: <CALCETrX6Oo00NXn2QfR=eOKD9wvWiov_=WBRwb7V266=hJ2Duw@mail.gmail.com>
Subject: Re: [PATCH 10/12] mm: x86: Invoke hypercall when page encryption
 status is changed
To:     Ashish Kalra <Ashish.Kalra@amd.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Radim Krcmar <rkrcmar@redhat.com>,
        Joerg Roedel <joro@8bytes.org>, Borislav Petkov <bp@suse.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        David Rientjes <rientjes@google.com>, X86 ML <x86@kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 12, 2020 at 5:18 PM Ashish Kalra <Ashish.Kalra@amd.com> wrote:
>
> From: Brijesh Singh <brijesh.singh@amd.com>
>
> Invoke a hypercall when a memory region is changed from encrypted ->
> decrypted and vice versa. Hypervisor need to know the page encryption
> status during the guest migration.

What happens if the guest memory status doesn't match what the
hypervisor thinks it is?  What happens if the guest gets migrated
between the hypercall and the associated flushes?
