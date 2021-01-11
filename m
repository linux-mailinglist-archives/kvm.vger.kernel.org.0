Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73ACF2F1A97
	for <lists+kvm@lfdr.de>; Mon, 11 Jan 2021 17:11:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388646AbhAKQKh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Jan 2021 11:10:37 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:38316 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728173AbhAKQKg (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 11 Jan 2021 11:10:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610381349;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IqZECK3bv/kq2PlxvYKy5vkzkPsMC3YF/nEVS5UP5IQ=;
        b=JoQjRxbx12PpYM0/R83+pZ/Z+7yVciGEMzeBkafbMznEUN5xY89Ao2rno+XQzIzZ0NOTAm
        4WvZdeFyc4j9JJe4RP8ThK5Bj+77Gbco9A6ixyd2KQYW7bUJjSibfRQ7fTgCtGVsBTuHqQ
        iu8b0WmzYsw8JZa42u0radtikwpFe28=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-425-O2U0HcbVM36YveqpPWI5Bw-1; Mon, 11 Jan 2021 11:09:07 -0500
X-MC-Unique: O2U0HcbVM36YveqpPWI5Bw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 04077803622;
        Mon, 11 Jan 2021 16:09:03 +0000 (UTC)
Received: from [10.36.115.103] (ovpn-115-103.ams2.redhat.com [10.36.115.103])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7DA6B19C59;
        Mon, 11 Jan 2021 16:08:39 +0000 (UTC)
Subject: Re: [PATCH 1/2] sysemu/runstate: Let runstate_is_running() return
 bool
To:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>,
        qemu-devel@nongnu.org
Cc:     Huacai Chen <chenhuacai@kernel.org>, Greg Kurz <groug@kaod.org>,
        "Michael S. Tsirkin" <mst@redhat.com>, qemu-trivial@nongnu.org,
        Amit Shah <amit@kernel.org>,
        Dmitry Fleytman <dmitry.fleytman@gmail.com>,
        qemu-arm@nongnu.org, John Snow <jsnow@redhat.com>,
        qemu-s390x@nongnu.org, Paul Durrant <paul@xen.org>,
        Anthony Perard <anthony.perard@citrix.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Gerd Hoffmann <kraxel@redhat.com>,
        Kevin Wolf <kwolf@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Max Reitz <mreitz@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Aurelien Jarno <aurelien@aurel32.net>,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Jason Wang <jasowang@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        =?UTF-8?Q?C=c3=a9dric_Le_Goater?= <clg@kaod.org>,
        Halil Pasic <pasic@linux.ibm.com>, Fam Zheng <fam@euphon.net>,
        qemu-ppc@nongnu.org, Paolo Bonzini <pbonzini@redhat.com>,
        kvm@vger.kernel.org, Stefano Stabellini <sstabellini@kernel.org>,
        xen-devel@lists.xenproject.org, Cornelia Huck <cohuck@redhat.com>,
        qemu-block@nongnu.org,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Sunil Muthuswamy <sunilmut@microsoft.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Richard Henderson <richard.henderson@linaro.org>,
        =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>,
        Laurent Vivier <laurent@vivier.eu>,
        Thomas Huth <thuth@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>
References: <20210111152020.1422021-1-philmd@redhat.com>
 <20210111152020.1422021-2-philmd@redhat.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat GmbH
Message-ID: <e8da7869-1c39-128a-b494-09ddc0d6b0e4@redhat.com>
Date:   Mon, 11 Jan 2021 17:08:38 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <20210111152020.1422021-2-philmd@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11.01.21 16:20, Philippe Mathieu-Daudé wrote:
> runstate_check() returns a boolean. runstate_is_running()
> returns what runstate_check() returns, also a boolean.
> 
> Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
> ---
>  include/sysemu/runstate.h | 2 +-
>  softmmu/runstate.c        | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/include/sysemu/runstate.h b/include/sysemu/runstate.h
> index e557f470d42..3ab35a039a0 100644
> --- a/include/sysemu/runstate.h
> +++ b/include/sysemu/runstate.h
> @@ -6,7 +6,7 @@
>  
>  bool runstate_check(RunState state);
>  void runstate_set(RunState new_state);
> -int runstate_is_running(void);
> +bool runstate_is_running(void);
>  bool runstate_needs_reset(void);
>  bool runstate_store(char *str, size_t size);
>  
> diff --git a/softmmu/runstate.c b/softmmu/runstate.c
> index 636aab0addb..c7a67147d17 100644
> --- a/softmmu/runstate.c
> +++ b/softmmu/runstate.c
> @@ -217,7 +217,7 @@ void runstate_set(RunState new_state)
>      current_run_state = new_state;
>  }
>  
> -int runstate_is_running(void)
> +bool runstate_is_running(void)
>  {
>      return runstate_check(RUN_STATE_RUNNING);
>  }
> 

Reviewed-by: David Hildenbrand <david@redhat.com>

-- 
Thanks,

David / dhildenb

