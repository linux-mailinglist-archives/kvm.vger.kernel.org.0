Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 310457A6A66
	for <lists+kvm@lfdr.de>; Tue, 19 Sep 2023 20:05:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232043AbjISSF6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Sep 2023 14:05:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230140AbjISSF4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Sep 2023 14:05:56 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D598C6
        for <kvm@vger.kernel.org>; Tue, 19 Sep 2023 11:05:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695146701;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yPQFDee6tmhjQOr4CBnPWVdaics0wkhWkFarLbL/j5Q=;
        b=BKriXNdGtyswcts/K3gC9+qGWpa2qZ6NdZqTZfq0rh/py6UHlihHwsW6R0gQ0GQ3wYOlK/
        /8EQKkqDnpU7y55ZXgoR8ZR2ZKolAZ/+6VweLi2UvfE3f2miH8yDNojVraS1uWYHzdHx2Q
        C8ytEYOvRAAZ2nqH1QRz35krEgTwnnI=
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com
 [209.85.166.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-479-uABn39bLOeOjNOFYfmtCoQ-1; Tue, 19 Sep 2023 14:04:59 -0400
X-MC-Unique: uABn39bLOeOjNOFYfmtCoQ-1
Received: by mail-il1-f199.google.com with SMTP id e9e14a558f8ab-34df876e560so47416725ab.0
        for <kvm@vger.kernel.org>; Tue, 19 Sep 2023 11:04:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695146698; x=1695751498;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yPQFDee6tmhjQOr4CBnPWVdaics0wkhWkFarLbL/j5Q=;
        b=nVOHdsp7yL7gHz6evtM23+3H9HXlV9Ho3TePDsnNXTb132h0QPkY6/VIOGX5ChnV/I
         eGemsDD9zQ0jbVjyS/QKFvhCWsu8x9ITojKThDl3BizKeANXts+Ca2Qypad1di6rctWM
         qjEf0AUvEFvcG3WEDlIAGDZRz09qp8lcQuyKFtD7DC8c+VG8CraGZ+Z73Q3k/jcrHfKY
         +wz1GKqMEnekhZlKNduXSyGyZcbFfhfqw31p0iHS6g+HD9DLvKVFRuzMgN7cr7x13Mwv
         isDjgXv3xuKBb6bMEx8119d6CyHKM4o5KymgAd9CBdvOZapTED3/Qa2MiDQdDQAJZTMu
         9WSw==
X-Gm-Message-State: AOJu0YxSbkGzowA7OAzzW+9WDOOaSN88nhpZEAGAc/yWZiukNzr5pfC8
        YNkQJW8ueP5C6dfgcor+35FaizC+IT8N9JcfQAgHnBSW9KAgnLsCl/N2D/B1tgzPgESy5ubb9jD
        uIjBYJhxA7qgkHxuSmkxy
X-Received: by 2002:a92:c10b:0:b0:350:ecf2:8eca with SMTP id p11-20020a92c10b000000b00350ecf28ecamr542598ile.19.1695146697699;
        Tue, 19 Sep 2023 11:04:57 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHow4QEWp5PgAICiygV3zUpB9qg2AEwKhayIppVcrOusKPypNKokF3av7XY+kYtGxweePqDSQ==
X-Received: by 2002:a92:c10b:0:b0:350:ecf2:8eca with SMTP id p11-20020a92c10b000000b00350ecf28ecamr542576ile.19.1695146697461;
        Tue, 19 Sep 2023 11:04:57 -0700 (PDT)
Received: from redhat.com ([38.15.60.12])
        by smtp.gmail.com with ESMTPSA id q18-20020a02cf12000000b004302760aa6bsm3522374jar.4.2023.09.19.11.04.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Sep 2023 11:04:56 -0700 (PDT)
Date:   Tue, 19 Sep 2023 12:04:56 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Cong Liu <liucong2@kylinos.cn>
Cc:     jgg@ziepe.ca, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] vfio: Fix uninitialized symbol and potential
 dereferencing errors in vfio_combine_iova_ranges
Message-ID: <20230919120456.1a68dc4d.alex.williamson@redhat.com>
In-Reply-To: <20230914090839.196314-1-liucong2@kylinos.cn>
References: <ZQGs6F5y3YzlAJaL@ziepe.ca>
        <20230914090839.196314-1-liucong2@kylinos.cn>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.35; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 14 Sep 2023 17:08:39 +0800
Cong Liu <liucong2@kylinos.cn> wrote:

> when compiling with smatch check, the following errors were encountered:
> 
> drivers/vfio/vfio_main.c:957 vfio_combine_iova_ranges() error: uninitialized symbol 'last'.
> drivers/vfio/vfio_main.c:978 vfio_combine_iova_ranges() error: potentially dereferencing uninitialized 'comb_end'.
> drivers/vfio/vfio_main.c:978 vfio_combine_iova_ranges() error: potentially dereferencing uninitialized 'comb_start'.
> 
> this patch fix these error.
> 
> Signed-off-by: Cong Liu <liucong2@kylinos.cn>
> ---
>  drivers/vfio/vfio_main.c | 15 +++++++++++++--
>  1 file changed, 13 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
> index 40732e8ed4c6..96d2f3030ebb 100644
> --- a/drivers/vfio/vfio_main.c
> +++ b/drivers/vfio/vfio_main.c
> @@ -938,14 +938,17 @@ static int vfio_ioctl_device_feature_migration(struct vfio_device *device,
>  void vfio_combine_iova_ranges(struct rb_root_cached *root, u32 cur_nodes,
>  			      u32 req_nodes)
>  {
> -	struct interval_tree_node *prev, *curr, *comb_start, *comb_end;
> +	struct interval_tree_node *prev, *curr;
> +	struct interval_tree_node *comb_start = NULL, *comb_end = NULL;
>  	unsigned long min_gap, curr_gap;
>  
>  	/* Special shortcut when a single range is required */
>  	if (req_nodes == 1) {
> -		unsigned long last;
> +		unsigned long last = 0;
>  
>  		comb_start = interval_tree_iter_first(root, 0, ULONG_MAX);
> +		if (!comb_start)
> +			return;
>  		curr = comb_start;
>  		while (curr) {
>  			last = curr->last;

@last no longer requires initialization with the @comb_start test.

However, all of these are testing for invalid parameters, which I think
we can eliminate if we simply introduce the following at the start of
the function:

        if (!cur_nodes || cur_nodes <= req_nodes ||
            WARN_ON(!req_nodes || !root->rb_root.rb_node))
                return;

At that point we're guaranteed to have any entry for both the above and
below first entry and there must be at least a second entry (or a
driver bug telling us there are more entries than actually exist) for
the next call below.  Thanks,

Alex


> @@ -963,6 +966,10 @@ void vfio_combine_iova_ranges(struct rb_root_cached *root, u32 cur_nodes,
>  		prev = NULL;
>  		min_gap = ULONG_MAX;
>  		curr = interval_tree_iter_first(root, 0, ULONG_MAX);
> +		if (!curr) {
> +			/* No more ranges to combine */
> +			break;
> +		}
>  		while (curr) {
>  			if (prev) {
>  				curr_gap = curr->start - prev->last;
> @@ -975,6 +982,10 @@ void vfio_combine_iova_ranges(struct rb_root_cached *root, u32 cur_nodes,
>  			prev = curr;
>  			curr = interval_tree_iter_next(curr, 0, ULONG_MAX);
>  		}
> +		if (!comb_start || !comb_end) {
> +			/* No more ranges to combine */
> +			break;
> +		}
>  		comb_start->last = comb_end->last;
>  		interval_tree_remove(comb_end, root);
>  		cur_nodes--;

