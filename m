Return-Path: <kvm+bounces-41237-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 06DC6A655D0
	for <lists+kvm@lfdr.de>; Mon, 17 Mar 2025 16:34:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4B0A97A97C5
	for <lists+kvm@lfdr.de>; Mon, 17 Mar 2025 15:32:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AB43924C066;
	Mon, 17 Mar 2025 15:32:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ikweImA7"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5015824C067
	for <kvm@vger.kernel.org>; Mon, 17 Mar 2025 15:32:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742225545; cv=none; b=MyDZqOsGbPzJ2sTPIOU6vxuKkqiBHPZ2RU6IYXhGJizCdTZ9vfyzFpRWaNL4Uox0/djA5kCHfvRK6M/E6oO4wqCPjY8TnBooN/O1kJaBYvUWYXwMQiXO6b9/vqHuULvQ/PQPKBd7Bw+CzHSCrLItfdH5vX0qrFlVCRDFQIm7bG0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742225545; c=relaxed/simple;
	bh=O5+Q/4q8DiNic//pMpygZaZKvx/Dan0yCiK5geuSGuk=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=BmVor2L957Hx/QZcZLP8KVOmmoiA2MM+Id587QKSZ7fHi7ainyvjU9aNLaujhhHhWARxGfcuKdJfKTLN979ulu22lnSCZE81qsTtSiTuBT6Z+W4UAoqfgIBeVzXzZmzaX6Y3BrCC5qkQpndB72VCdvX7TyfY/uIha90HgWg1MYQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ikweImA7; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1742225543;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=k6AP8qPgf7yOre7jra69M1oGbFQiEjvBM1isV3S1yxw=;
	b=ikweImA7D0948f6l5J4kqxcwLk5IBReHFbXur9JGqpmxjLwkCzbqeGpjYnEBkKVUFXjnPv
	uQ53nEcq5QxH6sysJhI/Qq+WLzDosQzOuwtOr41dpG3D8BwCM0F2ZZ0rjRiyt9ApHEoSCh
	ceOELy43+xDcJrAOmTbQU+839NK9sd0=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-79-rZ07XL0XNsqRgktiRCcYpg-1; Mon,
 17 Mar 2025 11:32:17 -0400
X-MC-Unique: rZ07XL0XNsqRgktiRCcYpg-1
X-Mimecast-MFC-AGG-ID: rZ07XL0XNsqRgktiRCcYpg_1742225534
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A6D9A180AF4D;
	Mon, 17 Mar 2025 15:32:13 +0000 (UTC)
Received: from blackfin.pond.sub.org (unknown [10.22.74.4])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5F423180094A;
	Mon, 17 Mar 2025 15:32:12 +0000 (UTC)
Received: by blackfin.pond.sub.org (Postfix, from userid 1000)
	id 4355821E675E; Mon, 17 Mar 2025 16:32:08 +0100 (CET)
From: Markus Armbruster <armbru@redhat.com>
To: Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Cc: Pierrick Bouvier <pierrick.bouvier@linaro.org>,  Anthony PERARD
 <anthony.perard@vates.tech>,  qemu-devel@nongnu.org,  qemu-ppc@nongnu.org,
  Yoshinori Sato <ysato@users.sourceforge.jp>,  Paul Durrant
 <paul@xen.org>,  Peter Xu <peterx@redhat.com>,  alex.bennee@linaro.org,
  Harsh Prateek Bora <harshpb@linux.ibm.com>,  David Hildenbrand
 <david@redhat.com>,  Alistair Francis <alistair.francis@wdc.com>,  Richard
 Henderson <richard.henderson@linaro.org>,  "Edgar E. Iglesias"
 <edgar.iglesias@gmail.com>,  Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
  Nicholas Piggin <npiggin@gmail.com>,  Daniel Henrique Barboza
 <danielhb413@gmail.com>,  qemu-riscv@nongnu.org,
  manos.pitsidianakis@linaro.org,  Palmer Dabbelt <palmer@dabbelt.com>,
  kvm@vger.kernel.org,  xen-devel@lists.xenproject.org,  Stefano Stabellini
 <sstabellini@kernel.org>,  Paolo Bonzini <pbonzini@redhat.com>,  Weiwei Li
 <liwei1518@gmail.com>,  Peter Maydell <peter.maydell@linaro.org>
Subject: Re: [PATCH v5 00/17] make system memory API available for common code
In-Reply-To: <3ce90214-a080-4ae8-86ff-9f8fd20f1733@linaro.org> ("Philippe
	=?utf-8?Q?Mathieu-Daud=C3=A9=22's?= message of "Mon, 17 Mar 2025 10:21:00
 +0100")
References: <20250314173139.2122904-1-pierrick.bouvier@linaro.org>
	<5951f731-b936-42eb-b3ff-bc66ef9c9414@linaro.org>
	<Z9R2mjfaNcsSuQWq@l14>
	<ee814e2f-c461-4cc2-889d-16bb2df44fdf@linaro.org>
	<3ce90214-a080-4ae8-86ff-9f8fd20f1733@linaro.org>
Date: Mon, 17 Mar 2025 16:32:08 +0100
Message-ID: <87h63rekqv.fsf@pond.sub.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

Philippe Mathieu-Daud=C3=A9 <philmd@linaro.org> writes:

> Hi,
>
> On 14/3/25 19:39, Pierrick Bouvier wrote:
>> On 3/14/25 11:34, Anthony PERARD wrote:
>>> On Fri, Mar 14, 2025 at 10:33:08AM -0700, Pierrick Bouvier wrote:
>>>> Hi,
>>>>
>>>> one patch is missing review:
>>>> [PATCH v5 12/17] hw/xen: add stubs for various functions.
>>>
>>> My "Acked-by" wasn't enough? Feel free try change it to "Reviewed-by"
>>> instead.
>>>
>> Those are differents. From what I understand, Reviewed implies Acked, bu=
t the opposite is not true. If it was, they would be equivalent.
>> Thanks.
>
> IIUC on QEMU Acked-by means "as a maintainer of files modified by
> this patch, I don't have objection on my area, as long as someone
> else takes the patch". It doesn't mean the patch has been reviewed.
>
> Please correct me if I'm wrong.

Documentation/process/submitting-patches.rst has some advice, but not
much.  Kernel docs are more thorough, and I believe the information
there applies to QEMU reasonably well:

https://docs.kernel.org/process/5.Posting.html#patch-formatting-and-changel=
ogs


