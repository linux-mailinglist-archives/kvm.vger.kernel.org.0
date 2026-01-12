Return-Path: <kvm+bounces-67710-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id A714AD1195D
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 10:46:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id A725D3052460
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 09:44:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7F76D34A78D;
	Mon, 12 Jan 2026 09:44:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WkOGbrry"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B4A43A1B5
	for <kvm@vger.kernel.org>; Mon, 12 Jan 2026 09:44:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768211046; cv=none; b=G9q8l2zI9V7xR613kBrhiE8hoSzb4lU8ZrnUMbaH41dSrz/Nt+p0ll/vu/jWmBIPlBgneILhj8J9fZ81aR1xRmJwFGfb/2ANu9LLF5s6i+6SJ+FFuDp2+jGl4wy35TO4u44l30XK5TAccKAyc7Q3elf2cohgflTnKrReYKkPJa8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768211046; c=relaxed/simple;
	bh=aenAroZJJ7js6vQTd2zo9GBYQgVIruLRICJMUc1Ug4A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uHtnMesW0TbvelINzopPFWubkw56dxN24l5MTDM1T0QpyQlM0348v7bojfVClcZ4gjDxBB3Ufy/d5OpJ9flagrWCVo7HuljJUrDuZhR4Cd7BRf+FngPmH5mkbjPsnLhwLU8rnUmzbXT5EtaThYE4lNK1Z5wBe4p7g+Ma3ZI9IuY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=WkOGbrry; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1768211044;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=flDfzf0/CQPBlAtFe2Zyw9+2STYvng3hxDlSiszF0ss=;
	b=WkOGbrrya/nY3Us+6v3Gz8SGiL4uopGOf5/KRrlOyJHeT0CV1FzQlVxurvvHgbMAJtoich
	nMRrmZMXmFMvVBEmw43SgxJkZ4hy/hDPK7AuuRe1c0OoZOpD7SFGr+m0gc7MDIKY5o9AJI
	3b/BxMLJz6VeGMSPKzf0HzAb6QyLuiY=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-259-w5zCYpl6Oeiyl0lXikt_jw-1; Mon,
 12 Jan 2026 04:44:00 -0500
X-MC-Unique: w5zCYpl6Oeiyl0lXikt_jw-1
X-Mimecast-MFC-AGG-ID: w5zCYpl6Oeiyl0lXikt_jw_1768211039
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B3DB21956094;
	Mon, 12 Jan 2026 09:43:58 +0000 (UTC)
Received: from sirius.home.kraxel.org (unknown [10.45.224.56])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 982881956048;
	Mon, 12 Jan 2026 09:43:57 +0000 (UTC)
Received: by sirius.home.kraxel.org (Postfix, from userid 1000)
	id 501E81800081; Mon, 12 Jan 2026 10:43:55 +0100 (CET)
Date: Mon, 12 Jan 2026 10:43:55 +0100
From: Gerd Hoffmann <kraxel@redhat.com>
To: Oliver Steffen <osteffen@redhat.com>
Cc: qemu-devel@nongnu.org, 
	Richard Henderson <richard.henderson@linaro.org>, Igor Mammedov <imammedo@redhat.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>, 
	Ani Sinha <anisinha@redhat.com>, Stefano Garzarella <sgarzare@redhat.com>, 
	Luigi Leonardi <leonardi@redhat.com>, Zhao Liu <zhao1.liu@intel.com>, 
	Joerg Roedel <joerg.roedel@amd.com>, kvm@vger.kernel.org, Eduardo Habkost <eduardo@habkost.net>, 
	"Michael S. Tsirkin" <mst@redhat.com>, Marcel Apfelbaum <marcel.apfelbaum@gmail.com>
Subject: Re: [PATCH v3 4/6] igvm: Add common function for finding parameter
 entries
Message-ID: <aWTB6UF-oh6kF14p@sirius.home.kraxel.org>
References: <20260109143413.293593-1-osteffen@redhat.com>
 <20260109143413.293593-5-osteffen@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260109143413.293593-5-osteffen@redhat.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

On Fri, Jan 09, 2026 at 03:34:11PM +0100, Oliver Steffen wrote:
> Move repeating code for finding the parameter entries in the IGVM
> backend out of the parameter handlers into a common function.
> ---
>  backends/igvm.c | 115 +++++++++++++++++++++++++-----------------------
>  1 file changed, 61 insertions(+), 54 deletions(-)
> 
> diff --git a/backends/igvm.c b/backends/igvm.c
> index dc1fd026cb..a797bd741c 100644
> --- a/backends/igvm.c
> +++ b/backends/igvm.c
> @@ -95,6 +95,18 @@ typedef struct QIgvm {
>      unsigned region_page_count;
>  } QIgvm;
>  
> +static QIgvmParameterData *qigvm_find_param_entry(QIgvm *igvm, const IGVM_VHS_PARAMETER *param) {
> +
> +    QIgvmParameterData *param_entry;
> +    QTAILQ_FOREACH(param_entry, &igvm->parameter_data, next)
> +    {
> +        if (param_entry->index == param->parameter_area_index) {
> +            return param_entry;
> +        }
> +    }
> +    return NULL;
> +}
> +
>  static int qigvm_directive_page_data(QIgvm *ctx, const uint8_t *header_data,
>                                       Error **errp);
>  static int qigvm_directive_vp_context(QIgvm *ctx, const uint8_t *header_data,
> @@ -576,57 +588,54 @@ static int qigvm_directive_memory_map(QIgvm *ctx, const uint8_t *header_data,
>      }
>  
>      /* Find the parameter area that should hold the memory map */
> -    QTAILQ_FOREACH(param_entry, &ctx->parameter_data, next)
> +    param_entry = qigvm_find_param_entry(ctx, param);
> +    if (param_entry != NULL)
>      {

if (param_entry == NULL) {
    // handle error if needed
    return;
}

take care,
  Gerd


