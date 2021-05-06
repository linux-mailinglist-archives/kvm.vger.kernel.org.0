Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AEE83755DA
	for <lists+kvm@lfdr.de>; Thu,  6 May 2021 16:45:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234925AbhEFOqt convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Thu, 6 May 2021 10:46:49 -0400
Received: from us-smtp-delivery-44.mimecast.com ([205.139.111.44]:57582 "EHLO
        us-smtp-delivery-44.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234759AbhEFOqr (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 6 May 2021 10:46:47 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-602-4Jbjb-DMNXiDclDRdlqWiQ-1; Thu, 06 May 2021 10:45:45 -0400
X-MC-Unique: 4Jbjb-DMNXiDclDRdlqWiQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 337B961242;
        Thu,  6 May 2021 14:45:43 +0000 (UTC)
Received: from bahia.lan (ovpn-112-247.ams2.redhat.com [10.36.112.247])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1045F19D9F;
        Thu,  6 May 2021 14:45:34 +0000 (UTC)
Date:   Thu, 6 May 2021 16:45:33 +0200
From:   Greg Kurz <groug@kaod.org>
To:     Philippe =?UTF-8?B?TWF0aGlldS1EYXVkw6k=?= <philmd@redhat.com>
Cc:     qemu-devel@nongnu.org, kvm@vger.kernel.org, qemu-ppc@nongnu.org,
        qemu-arm@nongnu.org, Gerd Hoffmann <kraxel@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Alex =?UTF-8?B?QmVubsOpZQ==?= <alex.bennee@linaro.org>,
        David Gibson <david@gibson.dropbear.id.au>
Subject: Re: [PATCH v2 9/9] target/ppc/kvm: Replace alloca() by g_malloc()
Message-ID: <20210506164533.040b8c39@bahia.lan>
In-Reply-To: <20210506133758.1749233-10-philmd@redhat.com>
References: <20210506133758.1749233-1-philmd@redhat.com>
        <20210506133758.1749233-10-philmd@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kaod.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu,  6 May 2021 15:37:58 +0200
Philippe Mathieu-Daudé <philmd@redhat.com> wrote:

> The ALLOCA(3) man-page mentions its "use is discouraged".
> 
> Replace it by a g_malloc() call.
> 
> Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
> ---

Reviewed-by: Greg Kurz <groug@kaod.org>

>  target/ppc/kvm.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/target/ppc/kvm.c b/target/ppc/kvm.c
> index 104a308abb5..63c458e2211 100644
> --- a/target/ppc/kvm.c
> +++ b/target/ppc/kvm.c
> @@ -2698,11 +2698,10 @@ int kvmppc_save_htab(QEMUFile *f, int fd, size_t bufsize, int64_t max_ns)
>  int kvmppc_load_htab_chunk(QEMUFile *f, int fd, uint32_t index,
>                             uint16_t n_valid, uint16_t n_invalid, Error **errp)
>  {
> -    struct kvm_get_htab_header *buf;
>      size_t chunksize = sizeof(*buf) + n_valid * HASH_PTE_SIZE_64;
> +    g_autofree struct kvm_get_htab_header *buf = g_malloc(chunksize);
>      ssize_t rc;
>  
> -    buf = alloca(chunksize);
>      buf->index = index;
>      buf->n_valid = n_valid;
>      buf->n_invalid = n_invalid;

