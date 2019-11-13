Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 47D15FB2D9
	for <lists+kvm@lfdr.de>; Wed, 13 Nov 2019 15:50:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727680AbfKMOuF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Nov 2019 09:50:05 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:52246 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726982AbfKMOuF (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 13 Nov 2019 09:50:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573656603;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=I2QpocGZg8paGDhHqoCyoy7YDgJcSMKZ4xM1a9farrU=;
        b=CEu3NB8AfCKstFiPmufFtgLeFiRjaLfCMIbPa3xcWX9YXr4ZrctA4b4tl5eK4/yxu/0IpN
        Phg9LxUTGDJqFeOyXuRo+o7jOA86Cl48gZZhAwlURuoOo3r6iFpactwpZuW0Ee8k1WqW1Y
        xGAHix9In0BtYF2MTprE8DwSefjVn4A=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-316-AQOCxp4zMYuCB6TCfIWrfA-1; Wed, 13 Nov 2019 09:50:00 -0500
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D3AC48A2471;
        Wed, 13 Nov 2019 14:49:58 +0000 (UTC)
Received: from localhost.localdomain (ovpn-116-183.ams2.redhat.com [10.36.116.183])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 3B1106293B;
        Wed, 13 Nov 2019 14:49:53 +0000 (UTC)
Subject: Re: [RFC 15/37] KVM: s390: protvirt: Add machine-check interruption
 injection controls
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, david@redhat.com,
        borntraeger@de.ibm.com, imbrenda@linux.ibm.com,
        mihajlov@linux.ibm.com, mimu@linux.ibm.com, cohuck@redhat.com,
        gor@linux.ibm.com
References: <20191024114059.102802-1-frankja@linux.ibm.com>
 <20191024114059.102802-16-frankja@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Message-ID: <6b0bef57-cbe3-99df-354e-061a12d4cc31@redhat.com>
Date:   Wed, 13 Nov 2019 15:49:51 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <20191024114059.102802-16-frankja@linux.ibm.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-MC-Unique: AQOCxp4zMYuCB6TCfIWrfA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 24/10/2019 13.40, Janosch Frank wrote:
> From: Michael Mueller <mimu@linux.ibm.com>
>=20
> The following fields are added to the sie control block type 4:
>      - Machine Check Interruption Code (mcic)
>      - External Damage Code (edc)
>      - Failing Storage Address (faddr)
>=20
> Signed-off-by: Michael Mueller <mimu@linux.ibm.com>
> ---
>  arch/s390/include/asm/kvm_host.h | 33 +++++++++++++++++++++++---------
>  1 file changed, 24 insertions(+), 9 deletions(-)
>=20
> diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm=
_host.h
> index 63fc32d38aa9..0ab309b7bf4c 100644
> --- a/arch/s390/include/asm/kvm_host.h
> +++ b/arch/s390/include/asm/kvm_host.h
> @@ -261,16 +261,31 @@ struct kvm_s390_sie_block {
>  #define HPID_VSIE=090x5
>  =09__u8=09hpid;=09=09=09/* 0x00b8 */
>  =09__u8=09reservedb9[7];=09=09/* 0x00b9 */
> -=09__u32=09eiparams;=09=09/* 0x00c0 */
> -=09__u16=09extcpuaddr;=09=09/* 0x00c4 */
> -=09__u16=09eic;=09=09=09/* 0x00c6 */
> +=09union {
> +=09=09struct {
> +=09=09=09__u32=09eiparams;=09/* 0x00c0 */
> +=09=09=09__u16=09extcpuaddr;=09/* 0x00c4 */
> +=09=09=09__u16=09eic;=09=09/* 0x00c6 */
> +=09=09};
> +=09=09__u64=09mcic;=09=09=09/* 0x00c0 */
> +=09} __packed;
>  =09__u32=09reservedc8;=09=09/* 0x00c8 */
> -=09__u16=09pgmilc;=09=09=09/* 0x00cc */
> -=09__u16=09iprcc;=09=09=09/* 0x00ce */
> -=09__u32=09dxc;=09=09=09/* 0x00d0 */
> -=09__u16=09mcn;=09=09=09/* 0x00d4 */
> -=09__u8=09perc;=09=09=09/* 0x00d6 */
> -=09__u8=09peratmid;=09=09/* 0x00d7 */
> +=09union {
> +=09=09struct {
> +=09=09=09__u16=09pgmilc;=09=09/* 0x00cc */
> +=09=09=09__u16=09iprcc;=09=09/* 0x00ce */
> +=09=09};
> +=09=09__u32=09edc;=09=09=09/* 0x00cc */
> +=09} __packed;
> +=09union {
> +=09=09struct {
> +=09=09=09__u32=09dxc;=09=09/* 0x00d0 */
> +=09=09=09__u16=09mcn;=09=09/* 0x00d4 */
> +=09=09=09__u8=09perc;=09=09/* 0x00d6 */
> +=09=09=09__u8=09peratmid;=09/* 0x00d7 */
> +=09=09};
> +=09=09__u64=09faddr;=09=09=09/* 0x00d0 */
> +=09} __packed;

Maybe drop the __packed keywords since the struct members are naturally
aligned anyway?

 Thomas

