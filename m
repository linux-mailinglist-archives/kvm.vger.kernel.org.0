Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B3F3676BA7
	for <lists+kvm@lfdr.de>; Sun, 22 Jan 2023 09:35:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229917AbjAVIfY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 22 Jan 2023 03:35:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229780AbjAVIfV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 22 Jan 2023 03:35:21 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D60FD1814C
        for <kvm@vger.kernel.org>; Sun, 22 Jan 2023 00:34:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674376476;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=LBOy3GEyTxqSKd3pw0Cq7/zzqUVdT2OzA5ZHrT96yhk=;
        b=BvUH5MtjiVPmwOsCCns1CFpTvDqe3N7B6WGGypnQAEiDxgvZpP7wGFg3jdy1m7W1px6z7J
        cO2R1jEPIe4ZqLFUQmCJeN8whu96MNk+i53bGqeYCcc99OUZ+i8zR3dYHQoS9bZzdYr7L7
        9PYuz4wNIx0Qme05f3XcUS/6InYAZ/A=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-134-iEzxtaR9NHOuPBiz4BMcIg-1; Sun, 22 Jan 2023 03:34:32 -0500
X-MC-Unique: iEzxtaR9NHOuPBiz4BMcIg-1
Received: by mail-ej1-f72.google.com with SMTP id nd38-20020a17090762a600b00871ff52c6b5so6003331ejc.0
        for <kvm@vger.kernel.org>; Sun, 22 Jan 2023 00:34:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LBOy3GEyTxqSKd3pw0Cq7/zzqUVdT2OzA5ZHrT96yhk=;
        b=xFAelesaXRkbKRFO725y98w5LJjOznuM0a4DVE0nqU7/GKYBnrN+6JGdcDVIxo2lGH
         wcvn+7oCBeNiomdevH0Ka6Gud5LfhbHMf9eIzzU8caJLQjohxTCeKxlhb4jyQf8wmRJw
         M7ScvK4XqJ0n5kamKL+4Wvf7FLl58jM48Rb6HEu9PGCtiV13VzxCV8OPEGXtJj7cGCz/
         rCURrsaSG+Ai6WH3265J7+oumXdDpYpuI0lJDuk1EXwFRMqrX9LU0rKsNRxLjXwl8F/x
         LNiQQ8CsOvaYuqdIPnKLXQip7GyjLcRbhu/z0SafRwmoE/IBUGZ5sW9FA9TmSQ1Tbg2A
         pJQA==
X-Gm-Message-State: AFqh2koN490lghyo8091fzZ0wSWzoNjtYUtKwqDeqZZOYw7izz69+oxg
        D+fSdi0qVv8N1Lb8DwTU00JUBwftAiacrkJOE89DyH9FRB45WEMIeDpgoAr1ahU3C0OrcL8kZiK
        khusqBfSBhKAJ
X-Received: by 2002:a17:906:d8ad:b0:875:54f5:740d with SMTP id qc13-20020a170906d8ad00b0087554f5740dmr18980190ejb.51.1674376471264;
        Sun, 22 Jan 2023 00:34:31 -0800 (PST)
X-Google-Smtp-Source: AMrXdXupkktggRT0GhSuPRcESSXkQviODPyb9ZmRHAGX+AHHUI13v12MW9XOdnRYvnmjPv5GEmYCQw==
X-Received: by 2002:a17:906:d8ad:b0:875:54f5:740d with SMTP id qc13-20020a170906d8ad00b0087554f5740dmr18980169ejb.51.1674376471041;
        Sun, 22 Jan 2023 00:34:31 -0800 (PST)
Received: from redhat.com ([2.52.149.29])
        by smtp.gmail.com with ESMTPSA id lb19-20020a170907785300b0084d1efe9af6sm20325371ejc.58.2023.01.22.00.34.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 Jan 2023 00:34:30 -0800 (PST)
Date:   Sun, 22 Jan 2023 03:34:26 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     "Seth Forshee (DigitalOcean)" <sforshee@digitalocean.com>
Cc:     Petr Mladek <pmladek@suse.com>, Jason Wang <jasowang@redhat.com>,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        "Seth Forshee (DigitalOcean)" <sforshee@kernel.org>,
        netdev@vger.kernel.org, live-patching@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] vhost: improve livepatch switching for heavily
 loaded vhost worker kthreads
Message-ID: <20230122032944-mutt-send-email-mst@kernel.org>
References: <20230120-vhost-klp-switching-v1-0-7c2b65519c43@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230120-vhost-klp-switching-v1-0-7c2b65519c43@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jan 20, 2023 at 04:12:20PM -0600, Seth Forshee (DigitalOcean) wrote:
> We've fairly regularaly seen liveptches which cannot transition within kpatch's
> timeout period due to busy vhost worker kthreads. In looking for a solution the
> only answer I found was to call klp_update_patch_state() from a safe location.
> I tried adding this call to vhost_worker(), and it works, but this creates the
> potential for problems if a livepatch attempted to patch vhost_worker().
> Without a call to klp_update_patch_state() fully loaded vhost kthreads can
> never switch because vhost_worker() will always appear on the stack, but with
> the call these kthreads can switch but will still be running the old version of
> vhost_worker().
> 
> To avoid this situation I've added a new function, klp_switch_current(), which
> switches the current task only if its stack does not include any function being
> patched. This allows kthreads to safely attempt switching themselves if a patch
> is pending. There is at least one downside, however. Since there's no way for
> the kthread to track whether it has already tried to switch for a pending patch
> it can end up calling klp_switch_current() repeatedly when it can never be
> safely switched.
> 
> I don't know whether this is the right solution, and I'm happy to try out other
> suggestions. But in my testing these patches proved effective in consistently
> switching heavily loaded vhost kthreads almost immediately.
> 
> To: Josh Poimboeuf <jpoimboe@kernel.org>
> To: Jiri Kosina <jikos@kernel.org>
> To: Miroslav Benes <mbenes@suse.cz>
> To: Petr Mladek <pmladek@suse.com>
> To: Joe Lawrence <joe.lawrence@redhat.com>
> To: "Michael S. Tsirkin" <mst@redhat.com>
> To: Jason Wang <jasowang@redhat.com>
> Cc: live-patching@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Cc: kvm@vger.kernel.org
> Cc: virtualization@lists.linux-foundation.org
> Cc: netdev@vger.kernel.org
> Signed-off-by: Seth Forshee (DigitalOcean) <sforshee@kernel.org>

Don't know enough about live patching to judge this.

I'll let livepatch maintainers judge this, and merge through
the livepatch tree if appropriate. For that:
Acked-by: Michael S. Tsirkin <mst@redhat.com>
but pls underestand this is more a 'looks ok superficially and
I don't have better ideas'  than 'I have reviewed this thoroughly'.

> 
> ---
> Seth Forshee (DigitalOcean) (2):
>       livepatch: add an interface for safely switching kthreads
>       vhost: check for pending livepatches from vhost worker kthreads
> 
>  drivers/vhost/vhost.c         |  4 ++++
>  include/linux/livepatch.h     |  2 ++
>  kernel/livepatch/transition.c | 11 +++++++++++
>  3 files changed, 17 insertions(+)
> ---
> base-commit: 5dc4c995db9eb45f6373a956eb1f69460e69e6d4
> change-id: 20230120-vhost-klp-switching-ba9a3ae38b8a
> 
> Best regards,
> -- 
> Seth Forshee (DigitalOcean) <sforshee@kernel.org>

