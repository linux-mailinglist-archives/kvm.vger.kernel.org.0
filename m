Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 675A1482F86
	for <lists+kvm@lfdr.de>; Mon,  3 Jan 2022 10:41:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232120AbiACJlD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Jan 2022 04:41:03 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:48028 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231166AbiACJlC (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 3 Jan 2022 04:41:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1641202861;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Pfr7nzjNFCMaHerfvymYyqevUR0lJktbumJnTzkRGiY=;
        b=d7R7U5O8Ydb/fbwOKNzFEZetcMqG2WuF8FESJybgDMDK4CkxWbSZ/SlHYJQxqvd27mtjh1
        dvo3CNt9IHrMm0o0w+wThO91xKmcveQAM3GI++5SFnJV1egioo4WK5pE5ng6OlxNKh+ob0
        bRq+qwl30IXABxMdKCS50Mt5TOE3h/c=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-66-XBFcUvNJMuiI-YCTxzl0Nw-1; Mon, 03 Jan 2022 04:41:00 -0500
X-MC-Unique: XBFcUvNJMuiI-YCTxzl0Nw-1
Received: by mail-ed1-f71.google.com with SMTP id dm10-20020a05640222ca00b003f808b5aa18so22482707edb.4
        for <kvm@vger.kernel.org>; Mon, 03 Jan 2022 01:41:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Pfr7nzjNFCMaHerfvymYyqevUR0lJktbumJnTzkRGiY=;
        b=ecv9nF0ThHh6KP7S4SvVSLPKaVoS+Er2NljBmUif3MPWJR2gSo2vZ+negKifuW+PNg
         zBPfKKDt7pNnx5B9fQ3/9j6MND/6bU/WIjRV6/RBdbxpEuiHM+Vj1+FS5Y2NynntDTu5
         T2lsOSFRDo3yV8VZU99kdcU6Q34A1+rbTwhU/iKj10L6ZYDxpXwYOILEl39TS9u2VZII
         z+wCXDW3pFKSZrumafO57KNkabE5W9LUNJn99GIe/3sc3SLL34dS/LPIJ3NaPwu/AeHb
         hZKiiER816KScVOppsKCipFNuSJViLb34KgQ9MjhHEWIjovitZ2rkkUD92ew2gZj4mCD
         mnTQ==
X-Gm-Message-State: AOAM531qyFc+ov42AQsNiZ9kHBb0huB8c2KZvlP1P3D23D3Recq1sqqd
        SbISBhR2+j4rz+Gf2bd1qb/naWY1qJUJeSyCiKoFRDtcr0dXmo/lJ5ILM2q1zouRflvFxtiNpwc
        PaV4IIh2DapCl
X-Received: by 2002:a17:906:4556:: with SMTP id s22mr35523717ejq.321.1641202859480;
        Mon, 03 Jan 2022 01:40:59 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzXmWc00Q66qCcpRjKVdNxzVhgAFaMG4VaaflGAUbiOtR2hHa0IcoUhFH7h5Bg7+RnOY0i0Rw==
X-Received: by 2002:a17:906:4556:: with SMTP id s22mr35523700ejq.321.1641202859270;
        Mon, 03 Jan 2022 01:40:59 -0800 (PST)
Received: from localhost (nat-pool-brq-u.redhat.com. [213.175.37.12])
        by smtp.gmail.com with ESMTPSA id s3sm2168691ejs.145.2022.01.03.01.40.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Jan 2022 01:40:58 -0800 (PST)
Date:   Mon, 3 Jan 2022 10:40:57 +0100
From:   Igor Mammedov <imammedo@redhat.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] KVM: x86: Forbid KVM_SET_CPUID{,2} after KVM_RUN
Message-ID: <20220103104057.4dcf7948@redhat.com>
In-Reply-To: <87mtkdqm7m.fsf@redhat.com>
References: <20211122175818.608220-1-vkuznets@redhat.com>
        <20211122175818.608220-3-vkuznets@redhat.com>
        <16368a89-99ea-e52c-47b6-bd006933ec1f@redhat.com>
        <20211227183253.45a03ca2@redhat.com>
        <61325b2b-dc93-5db2-2d0a-dd0900d947f2@redhat.com>
        <87mtkdqm7m.fsf@redhat.com>
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.30; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 03 Jan 2022 09:04:29 +0100
Vitaly Kuznetsov <vkuznets@redhat.com> wrote:

> Paolo Bonzini <pbonzini@redhat.com> writes:
> 
> > On 12/27/21 18:32, Igor Mammedov wrote:  
> >>> Tweaked and queued nevertheless, thanks.  
> >> it seems this patch breaks VCPU hotplug, in scenario:
> >> 
> >>    1. hotunplug existing VCPU (QEMU stores VCPU file descriptor in parked cpus list)
> >>    2. hotplug it again (unsuspecting QEMU reuses stored file descriptor when recreating VCPU)
> >> 
> >> RHBZ:https://bugzilla.redhat.com/show_bug.cgi?id=2028337#c11
> >>   
> >
> > The fix here would be (in QEMU) to not call KVM_SET_CPUID2 again. 
> > However, we need to work around it in KVM, and allow KVM_SET_CPUID2 if 
> > the data passed to the ioctl is the same that was set before.  
> 
> Are we sure the data is going to be *exactly* the same? In particular,
> when using vCPU fds from the parked list, do we keep the same
> APIC/x2APIC id when hotplugging? Or can we actually hotplug with a
> different id?

If I recall it right, it can be a different ID easily.

