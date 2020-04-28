Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E6A21BCF3F
	for <lists+kvm@lfdr.de>; Tue, 28 Apr 2020 23:58:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726180AbgD1V5r (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Apr 2020 17:57:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726274AbgD1V5o (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 28 Apr 2020 17:57:44 -0400
Received: from mail-il1-x142.google.com (mail-il1-x142.google.com [IPv6:2607:f8b0:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4234DC03C1AC
        for <kvm@vger.kernel.org>; Tue, 28 Apr 2020 14:57:44 -0700 (PDT)
Received: by mail-il1-x142.google.com with SMTP id w6so507718ilg.1
        for <kvm@vger.kernel.org>; Tue, 28 Apr 2020 14:57:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Io2WMO8492IJ58vES9hjWcjeSKOy0fwA74x2MUbiieQ=;
        b=i+etvV+A6H82xkMFH/Wlbyxxv5zUTTycXQCEGIQe4u2HkAeaatkzyJiu3wiKq8WCOp
         r5j9HSMmVyBVMm8KB8I3wsHSHlzajGYAvDX02jl7P7wdFbsx4j+hJkoNO9Jgyb0oYVHy
         elYH8z/IJ7NiZGRYfTw3IrvrJndVJ4AmDxh6bDMt70+OaAZOyDqHWYZsEFqEyX6O5Hip
         gj6JcZDmApaawYInA4N1YNDWXwTCIhwKxDHALZngxVTiRRS35ApB9r/IybQBX+4QE4GN
         oSD9smnKk0gVjIF+JBY2zXEwnUemVMyDNa8SpmXkffuTNSQqWA1juCiOrVJ5j6zpp7Cj
         ei/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Io2WMO8492IJ58vES9hjWcjeSKOy0fwA74x2MUbiieQ=;
        b=RwKMfi+ijAyqkBlLjjjJe8aFuHoQsccgX9C5cO2kf0IEyrFIw+z1sGMW1iPqCn/OZQ
         2eN5yEylu1dqG2ADShb2iCP7X9LmL3rupqrJiVOYDIvEe9fZuAJePP9XehgDi7Or/Vjg
         0xOivbXZfOr11WxkyBOLuh3QvH75KP0NDafJ4R97g+4Zd1IM6iaYF3C5zGStkcymn7Iq
         AKN61rDOF8gNrNJgHvrNn5XCDJPU+q0KkJNXH7iAtjz94pM+7oiNvluVZZ0nkNxChiBj
         GbBWv/79aTq2A8zcfHtgIht+qLN8ncAann7Ad40SsThmu0pVT86kQOX0JC/4qUTTZNwi
         510g==
X-Gm-Message-State: AGi0PuZ+zMRyyNCw10VwuOyVY5N2IGDZ56MITB4yqP09wfgtNeP5B5Gd
        mAPcQT7NB/fot/x8/Qnm6w9JI49GAXRHNZAXA2ALKA==
X-Google-Smtp-Source: APiQypLd6vCwcOl5dOCvVDnFlwdc7Aq16jZewq3oPeBM95t0Wqxw92H6H4X1szGZ0dllpY3xlNAcJGHTeAlbm3Cwg3Y=
X-Received: by 2002:a92:da4e:: with SMTP id p14mr28502177ilq.296.1588111063335;
 Tue, 28 Apr 2020 14:57:43 -0700 (PDT)
MIME-Version: 1.0
References: <20200423022550.15113-1-sean.j.christopherson@intel.com> <20200423022550.15113-8-sean.j.christopherson@intel.com>
In-Reply-To: <20200423022550.15113-8-sean.j.christopherson@intel.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Tue, 28 Apr 2020 14:57:32 -0700
Message-ID: <CALMp9eQnzROUKG0wUhtzpCJcoxv267nsAGZSZs5_dx2XkrC6EQ@mail.gmail.com>
Subject: Re: [PATCH 07/13] KVM: VMX: Split out architectural interrupt/NMI
 blocking checks
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Oliver Upton <oupton@google.com>,
        Peter Shier <pshier@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Apr 22, 2020 at 7:26 PM Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
>
> Move the architectural (non-KVM specific) interrupt/NMI blocking checks
> to a separate helper so that they can be used in a future patch by
> vmx_check_nested_events().
>
> No functional change intended.
>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Reviewed-by: Jim Mattson <jmattson@google.com>
