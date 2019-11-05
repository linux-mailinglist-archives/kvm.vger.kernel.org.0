Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4D374F0462
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2019 18:51:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390562AbfKERvi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Nov 2019 12:51:38 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:50446 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2389356AbfKERvi (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 5 Nov 2019 12:51:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1572976297;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Uo9kjmswlhWUUNuwyPvpSw/SqNl9A5yqvoUJKzoDx4I=;
        b=EmIkIGc9oylb8YfM8QoEGlTMs4DVwuFNOsg4gIC5nPY5/Yypoh1CGJh/t67U8GYn5tPNpf
        nR3x/KonVOyAzuNTxvcNqME64WQWFczFHswvrnipM0FVeD7HdhL68Z2BRXsN2xekuCS5Ya
        /jQyW3p0/VgwvmQw1jsumJSAcdrrpMA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-125-_WxGERA5PQWJiQ_5J89lFA-1; Tue, 05 Nov 2019 12:51:34 -0500
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B9BD18017DE;
        Tue,  5 Nov 2019 17:51:32 +0000 (UTC)
Received: from gondolin (unknown [10.36.118.27])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7C4AA19757;
        Tue,  5 Nov 2019 17:51:27 +0000 (UTC)
Date:   Tue, 5 Nov 2019 18:51:24 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org, thuth@redhat.com,
        david@redhat.com, borntraeger@de.ibm.com, imbrenda@linux.ibm.com,
        mihajlov@linux.ibm.com, mimu@linux.ibm.com, gor@linux.ibm.com
Subject: Re: [RFC 13/37] KVM: s390: protvirt: Add interruption injection
 controls
Message-ID: <20191105185124.495d4820.cohuck@redhat.com>
In-Reply-To: <20191024114059.102802-14-frankja@linux.ibm.com>
References: <20191024114059.102802-1-frankja@linux.ibm.com>
        <20191024114059.102802-14-frankja@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-MC-Unique: _WxGERA5PQWJiQ_5J89lFA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 24 Oct 2019 07:40:35 -0400
Janosch Frank <frankja@linux.ibm.com> wrote:

> From: Michael Mueller <mimu@linux.ibm.com>
>=20
> Define the interruption injection codes and the related fields in the
> sie control block for PVM interruption injection.
>=20
> Signed-off-by: Michael Mueller <mimu@linux.ibm.com>
> ---
>  arch/s390/include/asm/kvm_host.h | 25 +++++++++++++++++++++----
>  1 file changed, 21 insertions(+), 4 deletions(-)
>=20
> diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm=
_host.h
> index 6cc3b73ca904..82443236d4cc 100644
> --- a/arch/s390/include/asm/kvm_host.h
> +++ b/arch/s390/include/asm/kvm_host.h
> @@ -215,7 +215,15 @@ struct kvm_s390_sie_block {
>  =09__u8=09icptcode;=09=09/* 0x0050 */
>  =09__u8=09icptstatus;=09=09/* 0x0051 */
>  =09__u16=09ihcpu;=09=09=09/* 0x0052 */
> -=09__u8=09reserved54[2];=09=09/* 0x0054 */
> +=09__u8=09reserved54;=09=09/* 0x0054 */
> +#define IICTL_CODE_NONE=09=09 0x00
> +#define IICTL_CODE_MCHK=09=09 0x01
> +#define IICTL_CODE_EXT=09=09 0x02
> +#define IICTL_CODE_IO=09=09 0x03
> +#define IICTL_CODE_RESTART=09 0x04
> +#define IICTL_CODE_SPECIFICATION 0x10
> +#define IICTL_CODE_OPERAND=09 0x11
> +=09__u8=09iictl;=09=09=09/* 0x0055 */
>  =09__u16=09ipa;=09=09=09/* 0x0056 */
>  =09__u32=09ipb;=09=09=09/* 0x0058 */
>  =09__u32=09scaoh;=09=09=09/* 0x005c */
> @@ -252,7 +260,8 @@ struct kvm_s390_sie_block {
>  #define HPID_KVM=090x4
>  #define HPID_VSIE=090x5
>  =09__u8=09hpid;=09=09=09/* 0x00b8 */
> -=09__u8=09reservedb9[11];=09=09/* 0x00b9 */
> +=09__u8=09reservedb9[7];=09=09/* 0x00b9 */
> +=09__u32=09eiparams;=09=09/* 0x00c0 */
>  =09__u16=09extcpuaddr;=09=09/* 0x00c4 */
>  =09__u16=09eic;=09=09=09/* 0x00c6 */
>  =09__u32=09reservedc8;=09=09/* 0x00c8 */
> @@ -268,8 +277,16 @@ struct kvm_s390_sie_block {
>  =09__u8=09oai;=09=09=09/* 0x00e2 */
>  =09__u8=09armid;=09=09=09/* 0x00e3 */
>  =09__u8=09reservede4[4];=09=09/* 0x00e4 */
> -=09__u64=09tecmc;=09=09=09/* 0x00e8 */
> -=09__u8=09reservedf0[12];=09=09/* 0x00f0 */
> +=09union {
> +=09=09__u64=09tecmc;=09=09/* 0x00e8 */
> +=09=09struct {
> +=09=09=09__u16=09subchannel_id;=09/* 0x00e8 */
> +=09=09=09__u16=09subchannel_nr;=09/* 0x00ea */
> +=09=09=09__u32=09io_int_parm;=09/* 0x00ec */
> +=09=09=09__u32=09io_int_word;=09/* 0x00f0 */
> +=09=09};
> +=09} __packed;
> +=09__u8=09reservedf4[8];=09=09/* 0x00f4 */

IIUC, for protected guests, you won't get an interception for which
tecmc would be valid anymore, but need to put the I/O interruption
stuff at the same place, right?

My main issue is that this makes the control block definition a bit
ugly, since the f0 value that's unused in the non-protvirt case is not
obvious anymore; but I don't know how to express this without making it
even uglier :(

>  #define CRYCB_FORMAT_MASK 0x00000003
>  #define CRYCB_FORMAT0 0x00000000
>  #define CRYCB_FORMAT1 0x00000001

