Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F421E411772
	for <lists+kvm@lfdr.de>; Mon, 20 Sep 2021 16:48:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240771AbhITOuA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Sep 2021 10:50:00 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:47814 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231720AbhITOt7 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 20 Sep 2021 10:49:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632149312;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=pC8oD9A1Eh59kCOMJw501BXguKNk8McrmeoNHs1wQCQ=;
        b=Bi2mxkJC5puWvEx1t5pX8a9zgmjgmdlLiImCKytKWakH3AVPVJzVgtNam2QDbvTTfApzic
        NBQtR7wU63F3uO/clzZBXWzSl6qALp5Ix2Rb7VNLpp76I9K+79VPMuJFV78K/e8C44wxzc
        99FYMk40y6tdX+ceLZi437Im34T3GmE=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-493-4Q9q2PRdNRGjSyrnN9ndZw-1; Mon, 20 Sep 2021 10:48:31 -0400
X-MC-Unique: 4Q9q2PRdNRGjSyrnN9ndZw-1
Received: by mail-wr1-f70.google.com with SMTP id r7-20020a5d6947000000b0015e0f68a63bso6322289wrw.22
        for <kvm@vger.kernel.org>; Mon, 20 Sep 2021 07:48:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=pC8oD9A1Eh59kCOMJw501BXguKNk8McrmeoNHs1wQCQ=;
        b=ege5gdISwdAJTV2s4w0pN0hassxhsEupHbXmCSz3z1GdcB5BJkyJSSp/urY9rkS/Ls
         7vPlEQ2OoalSaYyMQqh6xrYuuHo1sBf9g+WKqDrAC7hUUN0gFioe2T++03o0huqgtPXK
         kzTVt9q48Kh3zEqC0aoVGA/pCPxnXk9Fmh+vNMaEfJ+JYPqcEb77Z5Nh/n7vjQ18EbQM
         2MaGfsy5ubmnqA2QGrkBUeKlk6U9ZA4WbCbabRjS8L/37uNRywNsd5ricDwZy6bJXgCz
         4VNqUXFAfckeyVY2cIR9J0Sl9uio5brTruieRBjRMtYcQA93sSYoh1AQmAKFyui7PLIV
         1gvA==
X-Gm-Message-State: AOAM532xCKtQFRmU5gW18xPiHo748iB+CgD/PEYIJhV4Pz1EgxgtJ8Ll
        0Z2HfH4RlU7F9J7XULpHGIY1Oet9iRkIJ965GVs7lED1o+KSU82XAjTk/xrtptB8a1nKCm05LEW
        pTf95kVqlgnXYpfhxu1yImmpyiksBQ1v6oVqkW1/RjBnqRkDJvhwTxdAkJ/L7iqXa
X-Received: by 2002:a05:600c:1d0e:: with SMTP id l14mr29105867wms.16.1632149309837;
        Mon, 20 Sep 2021 07:48:29 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy35kz+9NkjiYqLDc+67REwWW4vldY0n/NeldgiAEAGDzQeyqKQXi0xaZsmpC6C9sWGMlpdwA==
X-Received: by 2002:a05:600c:1d0e:: with SMTP id l14mr29105835wms.16.1632149309557;
        Mon, 20 Sep 2021 07:48:29 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id c15sm17056582wrc.83.2021.09.20.07.48.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Sep 2021 07:48:28 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Nitesh Narayan Lal <nitesh@redhat.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v5 0/8] KVM: Various fixes and improvements around
 kicking vCPUs
In-Reply-To: <20210903075141.403071-1-vkuznets@redhat.com>
References: <20210903075141.403071-1-vkuznets@redhat.com>
Date:   Mon, 20 Sep 2021 16:48:27 +0200
Message-ID: <87h7ef9ubo.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Vitaly Kuznetsov <vkuznets@redhat.com> writes:

> Patch6 fixes a real problem with ioapic_write_indirect() KVM does
> out-of-bounds access to stack memory.

Paolo,

while the rest of the series is certainly not urgent, PATCH6 seems to be
fixing a real problem introduced in 5.10. Would it be possible to send
it for one of the upcoming 5.15 rcs (and probably to stable@)?

Thanks!

-- 
Vitaly

