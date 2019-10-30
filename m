Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 582A8EA0C9
	for <lists+kvm@lfdr.de>; Wed, 30 Oct 2019 17:09:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728181AbfJ3Px2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Oct 2019 11:53:28 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:31447 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728176AbfJ3Px0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Oct 2019 11:53:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1572450805;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qGQexgbIQ/lTUeCZBGwAuXkr7OGKK+KDn7siBoNaDeE=;
        b=EYn/VWDQ6a5lGLWAxfh5/1bVxqFtlpch2MKJ+OZomDMGgSdJOUKRws4bdIDVT6hlehPMiH
        l59xzR+XoeKkVqt//nzGOF9kMY0QHrkdmDRw5+11uVPRhzcxYGgYk8Msr4ko2QIp06LpMk
        xogz/GqJNu/6eidd3+YaNAAegbjzmRQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-41-JFio7v4CNuSbvetI5pYpRA-1; Wed, 30 Oct 2019 11:53:21 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5327E107ACC0;
        Wed, 30 Oct 2019 15:53:20 +0000 (UTC)
Received: from [10.36.116.178] (ovpn-116-178.ams2.redhat.com [10.36.116.178])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 690885D70E;
        Wed, 30 Oct 2019 15:53:18 +0000 (UTC)
Subject: Re: [RFC 13/37] KVM: s390: protvirt: Add interruption injection
 controls
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, thuth@redhat.com,
        borntraeger@de.ibm.com, imbrenda@linux.ibm.com,
        mihajlov@linux.ibm.com, mimu@linux.ibm.com, cohuck@redhat.com,
        gor@linux.ibm.com
References: <20191024114059.102802-1-frankja@linux.ibm.com>
 <20191024114059.102802-14-frankja@linux.ibm.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat GmbH
Message-ID: <c09046eb-380f-d930-8e99-42b9cc8a62ae@redhat.com>
Date:   Wed, 30 Oct 2019 16:53:17 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20191024114059.102802-14-frankja@linux.ibm.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-MC-Unique: JFio7v4CNuSbvetI5pYpRA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 24.10.19 13:40, Janosch Frank wrote:
> From: Michael Mueller <mimu@linux.ibm.com>
>=20
> Define the interruption injection codes and the related fields in the
> sie control block for PVM interruption injection.
>=20
> Signed-off-by: Michael Mueller <mimu@linux.ibm.com>
> ---
>   arch/s390/include/asm/kvm_host.h | 25 +++++++++++++++++++++----
>   1 file changed, 21 insertions(+), 4 deletions(-)
>=20
> diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm=
_host.h
> index 6cc3b73ca904..82443236d4cc 100644
> --- a/arch/s390/include/asm/kvm_host.h
> +++ b/arch/s390/include/asm/kvm_host.h
> @@ -215,7 +215,15 @@ struct kvm_s390_sie_block {
>   =09__u8=09icptcode;=09=09/* 0x0050 */
>   =09__u8=09icptstatus;=09=09/* 0x0051 */
>   =09__u16=09ihcpu;=09=09=09/* 0x0052 */
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
>   =09__u16=09ipa;=09=09=09/* 0x0056 */
>   =09__u32=09ipb;=09=09=09/* 0x0058 */
>   =09__u32=09scaoh;=09=09=09/* 0x005c */
> @@ -252,7 +260,8 @@ struct kvm_s390_sie_block {
>   #define HPID_KVM=090x4
>   #define HPID_VSIE=090x5
>   =09__u8=09hpid;=09=09=09/* 0x00b8 */
> -=09__u8=09reservedb9[11];=09=09/* 0x00b9 */
> +=09__u8=09reservedb9[7];=09=09/* 0x00b9 */
> +=09__u32=09eiparams;=09=09/* 0x00c0 */
>   =09__u16=09extcpuaddr;=09=09/* 0x00c4 */
>   =09__u16=09eic;=09=09=09/* 0x00c6 */
>   =09__u32=09reservedc8;=09=09/* 0x00c8 */
> @@ -268,8 +277,16 @@ struct kvm_s390_sie_block {
>   =09__u8=09oai;=09=09=09/* 0x00e2 */
>   =09__u8=09armid;=09=09=09/* 0x00e3 */
>   =09__u8=09reservede4[4];=09=09/* 0x00e4 */
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

I only wonder if we should give this member a fitting name, e.g., "ioparams=
"

> +=09} __packed;
> +=09__u8=09reservedf4[8];=09=09/* 0x00f4 */
>   #define CRYCB_FORMAT_MASK 0x00000003
>   #define CRYCB_FORMAT0 0x00000000
>   #define CRYCB_FORMAT1 0x00000001
>=20


--=20

Thanks,

David / dhildenb

