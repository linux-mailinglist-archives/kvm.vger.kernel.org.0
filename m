Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21CB0204CBF
	for <lists+kvm@lfdr.de>; Tue, 23 Jun 2020 10:42:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731960AbgFWImh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Jun 2020 04:42:37 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:27428 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1731691AbgFWImh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Jun 2020 04:42:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592901755;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=cK1t9mkIlF76/WqKWi5+NrlN1e2lB7rFy+UvhGbGZjA=;
        b=PLf3zP970s8hebP6wy9b9wwycz4Z8LUh6grtcnmIvgXE0WO+EoUKTyZq4D9bzLh+e9HPxK
        cJhmD4L32oRnffzwNG4SGTjZ/ywLZCw3hBEp7xcp/Gec0AUpdWjS0mCqYWermwS2/TBUez
        cDNFB/quEo9UgM9uT8BGYx3HiA+46jk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-506-_hUjwL_MNNuQ90OepoCV9Q-1; Tue, 23 Jun 2020 04:42:33 -0400
X-MC-Unique: _hUjwL_MNNuQ90OepoCV9Q-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6055C184D152;
        Tue, 23 Jun 2020 08:42:32 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-112-170.ams2.redhat.com [10.36.112.170])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 238E278F0F;
        Tue, 23 Jun 2020 08:42:26 +0000 (UTC)
Subject: Re: [PATCH v9 2/2] s390/kvm: diagnose 0x318 sync and reset
To:     Collin Walling <walling@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Cc:     pbonzini@redhat.com, borntraeger@de.ibm.com, frankja@linux.ibm.com,
        david@redhat.com, cohuck@redhat.com, imbrenda@linux.ibm.com,
        heiko.carstens@de.ibm.com, gor@linux.ibm.com
References: <20200622154636.5499-1-walling@linux.ibm.com>
 <20200622154636.5499-3-walling@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <06bd4fde-ecdb-0795-bcab-e8f5fbabcd14@redhat.com>
Date:   Tue, 23 Jun 2020 10:42:25 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20200622154636.5499-3-walling@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 22/06/2020 17.46, Collin Walling wrote:
> DIAGNOSE 0x318 (diag318) sets information regarding the environment
> the VM is running in (Linux, z/VM, etc) and is observed via
> firmware/service events.
> 
> This is a privileged s390x instruction that must be intercepted by
> SIE. Userspace handles the instruction as well as migration. Data
> is communicated via VCPU register synchronization.
> 
> The Control Program Name Code (CPNC) is stored in the SIE block. The
> CPNC along with the Control Program Version Code (CPVC) are stored
> in the kvm_vcpu_arch struct.
> 
> This data is reset on load normal and clear resets.
> 
> Signed-off-by: Collin Walling <walling@linux.ibm.com>
> Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
> ---
>  arch/s390/include/asm/kvm_host.h |  4 +++-
>  arch/s390/include/uapi/asm/kvm.h |  5 ++++-
>  arch/s390/kvm/kvm-s390.c         | 11 ++++++++++-
>  arch/s390/kvm/vsie.c             |  1 +
>  include/uapi/linux/kvm.h         |  1 +
>  5 files changed, 19 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
> index 3d554887794e..8bdf6f1607ca 100644
> --- a/arch/s390/include/asm/kvm_host.h
> +++ b/arch/s390/include/asm/kvm_host.h
> @@ -260,7 +260,8 @@ struct kvm_s390_sie_block {
>  	__u32	scaol;			/* 0x0064 */
>  	__u8	sdf;			/* 0x0068 */
>  	__u8    epdx;			/* 0x0069 */
> -	__u8    reserved6a[2];		/* 0x006a */
> +	__u8	cpnc;			/* 0x006a */
> +	__u8	reserved6b;		/* 0x006b */
>  	__u32	todpr;			/* 0x006c */
>  #define GISA_FORMAT1 0x00000001
>  	__u32	gd;			/* 0x0070 */
> @@ -745,6 +746,7 @@ struct kvm_vcpu_arch {
>  	bool gs_enabled;
>  	bool skey_enabled;
>  	struct kvm_s390_pv_vcpu pv;
> +	union diag318_info diag318_info;
>  };
>  
>  struct kvm_vm_stat {
> diff --git a/arch/s390/include/uapi/asm/kvm.h b/arch/s390/include/uapi/asm/kvm.h
> index 436ec7636927..2ae1b660086c 100644
> --- a/arch/s390/include/uapi/asm/kvm.h
> +++ b/arch/s390/include/uapi/asm/kvm.h
> @@ -231,11 +231,13 @@ struct kvm_guest_debug_arch {
>  #define KVM_SYNC_GSCB   (1UL << 9)
>  #define KVM_SYNC_BPBC   (1UL << 10)
>  #define KVM_SYNC_ETOKEN (1UL << 11)
> +#define KVM_SYNC_DIAG318 (1UL << 12)
>  
>  #define KVM_SYNC_S390_VALID_FIELDS \
>  	(KVM_SYNC_PREFIX | KVM_SYNC_GPRS | KVM_SYNC_ACRS | KVM_SYNC_CRS | \
>  	 KVM_SYNC_ARCH0 | KVM_SYNC_PFAULT | KVM_SYNC_VRS | KVM_SYNC_RICCB | \
> -	 KVM_SYNC_FPRS | KVM_SYNC_GSCB | KVM_SYNC_BPBC | KVM_SYNC_ETOKEN)
> +	 KVM_SYNC_FPRS | KVM_SYNC_GSCB | KVM_SYNC_BPBC | KVM_SYNC_ETOKEN | \
> +	 KVM_SYNC_DIAG318)
>  
>  /* length and alignment of the sdnx as a power of two */
>  #define SDNXC 8
> @@ -254,6 +256,7 @@ struct kvm_sync_regs {
>  	__u64 pft;	/* pfault token [PFAULT] */
>  	__u64 pfs;	/* pfault select [PFAULT] */
>  	__u64 pfc;	/* pfault compare [PFAULT] */
> +	__u64 diag318;	/* diagnose 0x318 info */
>  	union {
>  		__u64 vrs[32][2];	/* vector registers (KVM_SYNC_VRS) */
>  		__u64 fprs[16];		/* fp registers (KVM_SYNC_FPRS) */

It's been a while since I touched kvm_sync_regs the last time ... but
can your really extend this structure right in the middle without
breaking older user spaces (ie. QEMUs) ? This is a uapi header ... so I
think you rather have to add this add the end or e.g. put it into the
padding2 region or something like that...? Or do I miss something?

 Thomas

