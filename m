Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B995BFC91A
	for <lists+kvm@lfdr.de>; Thu, 14 Nov 2019 15:44:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726605AbfKNOoc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Nov 2019 09:44:32 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:50421 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726179AbfKNOoc (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 14 Nov 2019 09:44:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573742671;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=I5JOOBRZ00n8io3w1WR77ggp8kXBzEKChjwFUxDMPWY=;
        b=RnlxrGz8gKtiBWjG9a6cgmmWsr+TAqLdACIrf0W+8ByW43Ytqm3/oK302n3BY+/31sEKux
        BT0feWkrRnpeJ5kPdWNpdMFja/io9LYP054Bix0ZpSckPwCq9jq6XIdQvRDlpZo9IqRCp2
        nc8BGslojT5r4r0hWY6PYmntHbjGZ8E=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-139-wzi85W8ZMY26n7r_wEsljw-1; Thu, 14 Nov 2019 09:44:29 -0500
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 028A8805A63;
        Thu, 14 Nov 2019 14:44:28 +0000 (UTC)
Received: from localhost.localdomain (ovpn-116-89.ams2.redhat.com [10.36.116.89])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 75DCE472EC;
        Thu, 14 Nov 2019 14:44:23 +0000 (UTC)
Subject: Re: [RFC 19/37] KVM: s390: protvirt: Add new gprs location handling
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, david@redhat.com,
        borntraeger@de.ibm.com, imbrenda@linux.ibm.com,
        mihajlov@linux.ibm.com, mimu@linux.ibm.com, cohuck@redhat.com,
        gor@linux.ibm.com
References: <20191024114059.102802-1-frankja@linux.ibm.com>
 <20191024114059.102802-20-frankja@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Message-ID: <049b8634-c195-4b3f-4d9c-83a1df7f03f7@redhat.com>
Date:   Thu, 14 Nov 2019 15:44:18 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <20191024114059.102802-20-frankja@linux.ibm.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-MC-Unique: wzi85W8ZMY26n7r_wEsljw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 24/10/2019 13.40, Janosch Frank wrote:
> Guest registers for protected guests are stored at offset 0x380.
>=20
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> ---
>  arch/s390/include/asm/kvm_host.h |  4 +++-
>  arch/s390/kvm/kvm-s390.c         | 11 +++++++++++
>  2 files changed, 14 insertions(+), 1 deletion(-)
>=20
> diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm=
_host.h
> index 0ab309b7bf4c..5deabf9734d9 100644
> --- a/arch/s390/include/asm/kvm_host.h
> +++ b/arch/s390/include/asm/kvm_host.h
> @@ -336,7 +336,9 @@ struct kvm_s390_itdb {
>  struct sie_page {
>  =09struct kvm_s390_sie_block sie_block;
>  =09struct mcck_volatile_info mcck_info;=09/* 0x0200 */
> -=09__u8 reserved218[1000];=09=09/* 0x0218 */
> +=09__u8 reserved218[360];=09=09/* 0x0218 */
> +=09__u64 pv_grregs[16];=09=09/* 0x380 */
> +=09__u8 reserved400[512];

Maybe add a "/* 0x400 */" comment to be consisten with the other lines?

>  =09struct kvm_s390_itdb itdb;=09/* 0x0600 */
>  =09__u8 reserved700[2304];=09=09/* 0x0700 */
>  };

 Thomas

