Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC5ED3EA4FB
	for <lists+kvm@lfdr.de>; Thu, 12 Aug 2021 14:57:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237570AbhHLM50 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Aug 2021 08:57:26 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:56326 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237563AbhHLM5Z (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 12 Aug 2021 08:57:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628773019;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=b0TEj2MZyoFtFnfJ+B/a+Es9aPKA2caU/WWBMKJJWQc=;
        b=h3WLRRjAaVZnOa+c0Gk3FfI8P6YpLdAetxqDlofU6Q41Z6j2au2PcUvnXhT6sfNFJoYhzZ
        1x9xSIwKe0olenZxsM7CELjVaXMd/zHgGmX7+bHfk6wl5zEKC3EFfmHFbDgThGCEW8XT8K
        qiv5oYLGDMvP/UgviQ7LeI8003YEwP8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-454-rNX5EtOUNDaC6xCPaMrh5Q-1; Thu, 12 Aug 2021 08:56:56 -0400
X-MC-Unique: rNX5EtOUNDaC6xCPaMrh5Q-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 514B0A0C0A;
        Thu, 12 Aug 2021 12:56:55 +0000 (UTC)
Received: from localhost (unknown [10.39.193.33])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 4EB0410013C1;
        Thu, 12 Aug 2021 12:56:51 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Pierre Morel <pmorel@linux.ibm.com>, linux-s390@vger.kernel.org
Cc:     frankja@linux.ibm.com, thuth@redhat.com, kvm@vger.kernel.org,
        imbrenda@linux.ibm.com, david@redhat.com
Subject: Re: [kvm-unit-tests PATCH v2 1/4] s390x: lib: Add SCLP toplogy
 nested level
In-Reply-To: <1628612544-25130-2-git-send-email-pmorel@linux.ibm.com>
Organization: Red Hat GmbH
References: <1628612544-25130-1-git-send-email-pmorel@linux.ibm.com>
 <1628612544-25130-2-git-send-email-pmorel@linux.ibm.com>
User-Agent: Notmuch/0.32.1 (https://notmuchmail.org)
Date:   Thu, 12 Aug 2021 14:56:49 +0200
Message-ID: <87czqivn1q.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 10 2021, Pierre Morel <pmorel@linux.ibm.com> wrote:

> The maximum CPU Topology nested level is available with the SCLP
> READ_INFO command inside the byte at offset 15 of the ReadInfo
> structure.
>
> Let's return this information to check the number of topology nested
> information available with the STSI 15.1.x instruction.
>
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> ---
>  lib/s390x/sclp.c | 6 ++++++
>  lib/s390x/sclp.h | 4 +++-
>  2 files changed, 9 insertions(+), 1 deletion(-)
>
> diff --git a/lib/s390x/sclp.c b/lib/s390x/sclp.c
> index 9502d161..ee379ddf 100644
> --- a/lib/s390x/sclp.c
> +++ b/lib/s390x/sclp.c
> @@ -123,6 +123,12 @@ int sclp_get_cpu_num(void)
>  	return read_info->entries_cpu;
>  }
>  
> +int sclp_get_stsi_parm(void)
> +{
> +	assert(read_info);
> +	return read_info->stsi_parm;

Is this a generic "stsi parm", or always the concrete topology nested
level? IOW, is that name good, or too generic?

> +}
> +
>  CPUEntry *sclp_get_cpu_entries(void)
>  {
>  	assert(read_info);

