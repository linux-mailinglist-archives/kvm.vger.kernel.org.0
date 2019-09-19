Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 399EEB7E61
	for <lists+kvm@lfdr.de>; Thu, 19 Sep 2019 17:40:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389893AbfISPk3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Sep 2019 11:40:29 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:37583 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S2389927AbfISPk2 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 19 Sep 2019 11:40:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1568907619;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=40X0vm8+7OBVX9kW6gTq2puO5TD3LRpWUOSeujBTwSI=;
        b=YtwDaMtP5ug7thGk5OHWLmAHaf7cs/LHSdjJpOF9GcOzjv2CmL9SEaxqlPBhBk6Vo5uyJE
        z+PA6CxD01xpQnqsD8s1MjO7UdgalzGBTr8O1OuaG0GX/1h+19gF10pbdOgx1HQZkAofQv
        +u3THp0Ynavns7FHsKOM9B3T71OE45A=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-269-px-tZoZlOwCJNo9E5Yj-NA-1; Thu, 19 Sep 2019 11:40:08 -0400
Received: by mail-wr1-f69.google.com with SMTP id w10so1239349wrl.5
        for <kvm@vger.kernel.org>; Thu, 19 Sep 2019 08:40:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=IuQngF1BoEvQ6fP1U7DbaQBImeULLxoa7zH+YgkADWs=;
        b=ppsIDd083Hm7EFwTeI1xLZYj8R/67pfx5LbWTaHpLfK/SH3cfvCP03SENFHFIzHqmY
         yJFuh5l/6YeuMEZJqTjADs32pMeZVmBPDmNrjSAFLLuEjz5BluONbowk9th3f0y4GvRM
         nHqEthTl99jhIHUA5kWXRzE3DEAGJceVIdlqfosz7aDLeWh+B2DreSE7hnQLYrojRi/t
         fQR+tVJa5W+LRQHlhyxvZCKf5nhLmwQTnpfcivtObsDH0knHDjBdHNQwvQE483Iwmt0+
         o9AXYV3cCnj3bwcosTbkj5vsNVSZP/zyxd03C6n/iF5yO/IdBeOoo9dPc0EUbK0jxGin
         WFIA==
X-Gm-Message-State: APjAAAWhisNqpmvPaKlcIaGuSrJtngkHPwJvO+3/JBuJRt73n1owqUY/
        K6N+ugyigL3GWXx4ZYUsaSQ3XwrWnvuZjM5HTRQW/PNkpPmMfxweoXBmvaiMQCnTisunYzb+f10
        mB5Y/n/U+TvDz
X-Received: by 2002:a5d:4647:: with SMTP id j7mr7581970wrs.106.1568907603864;
        Thu, 19 Sep 2019 08:40:03 -0700 (PDT)
X-Google-Smtp-Source: APXvYqz+OjakhgvaDtsfzFmaFL97O8csbbK+Vo5VIxwaqYYZyJpLvjwzE0u+steLkcP97rvOtdgeNw==
X-Received: by 2002:a5d:4647:: with SMTP id j7mr7581956wrs.106.1568907603602;
        Thu, 19 Sep 2019 08:40:03 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c46c:2acb:d8d2:21d8? ([2001:b07:6468:f312:c46c:2acb:d8d2:21d8])
        by smtp.gmail.com with ESMTPSA id y3sm9581998wrw.83.2019.09.19.08.40.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 19 Sep 2019 08:40:03 -0700 (PDT)
Subject: Re: [RFC patch 14/15] workpending: Provide infrastructure for work
 before entering a guest
To:     Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>
Cc:     x86@kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Andy Lutomirski <luto@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Marc Zyngier <maz@kernel.org>, kvm@vger.kernel.org,
        linux-arch@vger.kernel.org
References: <20190919150314.054351477@linutronix.de>
 <20190919150809.860645841@linutronix.de>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <0cc964dc-4d00-05ec-1ed1-f6cee7370d7b@redhat.com>
Date:   Thu, 19 Sep 2019 17:40:01 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190919150809.860645841@linutronix.de>
Content-Language: en-US
X-MC-Unique: px-tZoZlOwCJNo9E5Yj-NA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Quick API review before I dive into the implementation.

On 19/09/19 17:03, Thomas Gleixner wrote:
> +=09/*
> +=09 * Before returning to guest mode handle all pending work
> +=09 */
> +=09if (ti_work & _TIF_SIGPENDING) {
> +=09=09vcpu->run->exit_reason =3D KVM_EXIT_INTR;
> +=09=09vcpu->stat.signal_exits++;
> +=09=09return -EINTR;
> +=09}
> +
> +=09if (ti_work & _TIF_NEED_RESCHED) {
> +=09=09srcu_read_unlock(&kvm->srcu, vcpu->srcu_idx);
> +=09=09schedule();
> +=09=09vcpu->srcu_idx =3D srcu_read_lock(&kvm->srcu);
> +=09}
> +
> +=09if (ti_work & _TIF_PATCH_PENDING) {
> +=09=09srcu_read_unlock(&kvm->srcu, vcpu->srcu_idx);
> +=09=09klp_update_patch_state(current);
> +=09=09vcpu->srcu_idx =3D srcu_read_lock(&kvm->srcu);
> +=09}
> +
> +=09if (ti_work & _TIF_NOTIFY_RESUME) {
> +=09=09srcu_read_unlock(&kvm->srcu, vcpu->srcu_idx);
> +=09=09clear_thread_flag(TIF_NOTIFY_RESUME);
> +=09=09tracehook_notify_resume(NULL);
> +=09=09vcpu->srcu_idx =3D srcu_read_lock(&kvm->srcu);
> +=09}
> +
> +=09/* Any extra architecture specific work */
> +=09return arch_exit_to_guestmode_work(kvm, vcpu, ti_work);
> +}

Perhaps, in virt/kvm/kvm_main.c:

int kvm_exit_to_guestmode_work(struct kvm *kvm, struct kvm_vcpu *vcpu,
=09=09=09=09unsigned long ti_work)
{
=09int r;

=09/*
=09 * Before returning to guest mode handle all pending work
=09 */
=09if (ti_work & _TIF_SIGPENDING) {
=09=09vcpu->run->exit_reason =3D KVM_EXIT_INTR;
=09=09vcpu->stat.signal_exits++;
=09=09return -EINTR;
=09}

=09srcu_read_unlock(&kvm->srcu, vcpu->srcu_idx);
=09core_exit_to_guestmode_work(ti_work);
=09vcpu->srcu_idx =3D srcu_read_lock(&kvm->srcu);

=09return r;
}

and in kernel/entry/common.c:

int core_exit_to_guestmode_work(unsigned long ti_work)
{
=09/*
=09 * Before returning to guest mode handle all pending work
=09 */
=09if (ti_work & _TIF_NEED_RESCHED)
=09=09schedule();

=09if (ti_work & _TIF_PATCH_PENDING)
=09=09klp_update_patch_state(current);

=09if (ti_work & _TIF_NOTIFY_RESUME) {
=09=09clear_thread_flag(TIF_NOTIFY_RESUME);
=09=09tracehook_notify_resume(NULL);
=09}
=09return arch_exit_to_guestmode_work(ti_work);
}

so that kernel/entry/ is not polluted with KVM structs and APIs.

Perhaps even extract the body of core_exit_to_usermode_work's while loop
to a separate function, and call it as

=09core_exit_to_usermode_work_once(NULL,
=09=09=09=09ti_work & EXIT_TO_GUESTMODE_WORK);

from core_exit_to_guestmode_work.

In general I don't mind having these exit_to_guestmode functions in
kvm_host.h, and only having entry-common.h export EXIT_TO_GUESTMODE_WORK
and ARCH_EXIT_TO_GUESTMODE_WORK.  Unless you had good reasons to do the
opposite...

Paolo

