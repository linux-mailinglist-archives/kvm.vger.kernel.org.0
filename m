Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B63F16C191
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2020 14:02:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729869AbgBYNCD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Feb 2020 08:02:03 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:52619 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729179AbgBYNCC (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 25 Feb 2020 08:02:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582635721;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=V74O8WaAFCh9o57K0pW1wsY1UghQBBpm/WuMhKnChp8=;
        b=a5gLiT14mK3f3TZo1opahTUuKYXKDnVk70tWRlL140MA0V9m3oQEP7p1FUT1tfxI5C+iyW
        aW5ccNSrGQUciETx4fQ+rj38MyBGwXdrEmzgOTsMX2WFY41YiAK6BURVBJ3SnfFbeAylXg
        gkXyLDNaeeqP342THWXAqPi7+scBXFc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-404-hr5gydBENMy9spuw2aA7Qw-1; Tue, 25 Feb 2020 08:01:57 -0500
X-MC-Unique: hr5gydBENMy9spuw2aA7Qw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E7C78801E53;
        Tue, 25 Feb 2020 13:01:55 +0000 (UTC)
Received: from gondolin (dhcp-192-175.str.redhat.com [10.33.192.175])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 15720271A0;
        Tue, 25 Feb 2020 13:01:53 +0000 (UTC)
Date:   Tue, 25 Feb 2020 14:01:51 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     David Hildenbrand <david@redhat.com>,
        Janosch Frank <frankja@linux.vnet.ibm.com>,
        KVM <kvm@vger.kernel.org>, Thomas Huth <thuth@redhat.com>,
        Ulrich Weigand <Ulrich.Weigand@de.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Michael Mueller <mimu@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>
Subject: Re: [PATCH v4 28/36] KVM: s390: protvirt: Report CPU state to
 Ultravisor
Message-ID: <20200225140151.5e639df1.cohuck@redhat.com>
In-Reply-To: <d75b4759-9fff-fef0-e6ec-09dd81a01355@de.ibm.com>
References: <20200224114107.4646-1-borntraeger@de.ibm.com>
        <20200224114107.4646-29-borntraeger@de.ibm.com>
        <3c653e60-5ef4-4b81-3bbd-4d72144b9d0b@redhat.com>
        <d75b4759-9fff-fef0-e6ec-09dd81a01355@de.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 25 Feb 2020 09:29:42 +0100
Christian Borntraeger <borntraeger@de.ibm.com> wrote:

> On 24.02.20 20:05, David Hildenbrand wrote:
> > On 24.02.20 12:40, Christian Borntraeger wrote:  
> >> From: Janosch Frank <frankja@linux.ibm.com>
> >>
> >> VCPU states have to be reported to the ultravisor for SIGP
> >> interpretation, kdump, kexec and reboot.
> >>
> >> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> >> Reviewed-by: Thomas Huth <thuth@redhat.com>
> >> Reviewed-by: Cornelia Huck <cohuck@redhat.com>
> >> [borntraeger@de.ibm.com: patch merging, splitting, fixing]
> >> Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>  
> > 

> Looks now like:
> 
> @@ -4445,18 +4451,27 @@ static void __enable_ibs_on_vcpu(struct kvm_vcpu *vcpu)
>         kvm_s390_sync_request(KVM_REQ_ENABLE_IBS, vcpu);
>  }
> 
> -void kvm_s390_vcpu_start(struct kvm_vcpu *vcpu)
> +int kvm_s390_vcpu_start(struct kvm_vcpu *vcpu)
>  {
> -       int i, online_vcpus, started_vcpus = 0;
> +       int i, online_vcpus, r = 0, started_vcpus = 0;
> 
>         if (!is_vcpu_stopped(vcpu))
> -               return;
> +               return 0;
> 
>         trace_kvm_s390_vcpu_start_stop(vcpu->vcpu_id, 1);
>         /* Only one cpu at a time may enter/leave the STOPPED state. */
>         spin_lock(&vcpu->kvm->arch.start_stop_lock);
>         online_vcpus = atomic_read(&vcpu->kvm->online_vcpus);
> 
> +       /* Let's tell the UV that we want to change into the operating state */
> +       if (kvm_s390_pv_cpu_is_protected(vcpu)) {
> +               r = kvm_s390_pv_set_cpu_state(vcpu, PV_CPU_STATE_OPR);
> +               if (r) {
> +                       spin_unlock(&vcpu->kvm->arch.start_stop_lock);
> +                       return r;
> +               }
> +       }
> +
>         for (i = 0; i < online_vcpus; i++) {
>                 if (!is_vcpu_stopped(vcpu->kvm->vcpus[i]))
>                         started_vcpus++;
> @@ -4481,22 +4496,31 @@ void kvm_s390_vcpu_start(struct kvm_vcpu *vcpu)
>          */
>         kvm_make_request(KVM_REQ_TLB_FLUSH, vcpu);
>         spin_unlock(&vcpu->kvm->arch.start_stop_lock);
> -       return;
> +       return r;
>  }
> 
> 

Hm, this is actually one of the cases where posting a new patch would
be less confusing than not doing so :)

