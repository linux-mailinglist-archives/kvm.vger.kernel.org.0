Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE53879BB32
	for <lists+kvm@lfdr.de>; Tue, 12 Sep 2023 02:12:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234022AbjIKUsH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Sep 2023 16:48:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244019AbjIKSp3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Sep 2023 14:45:29 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7A7161AB
        for <kvm@vger.kernel.org>; Mon, 11 Sep 2023 11:44:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1694457875;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ovvc9S0M0fusmEOptIxpRYf51VbT2wJC8z+64gwHvT4=;
        b=hjgIAKEQ03bF2LZPoZO/epEHQdKhFDJn5A6an4pF5wNj34mUVzfXVaixzNtIG9qHqcgX0h
        DHo36lB/cky3kVU4Ad65NyiD821BxkLksfehw3Qz6qGTNLZXp9WI9+bDvVXME3YNocpTA5
        1RudtL6g7IAE17P+av/RV5VilOPpF6E=
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com
 [209.85.166.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-536-Q95OtH0MMbGVxS0ijYcbNQ-1; Mon, 11 Sep 2023 14:44:33 -0400
X-MC-Unique: Q95OtH0MMbGVxS0ijYcbNQ-1
Received: by mail-io1-f71.google.com with SMTP id ca18e2360f4ac-7868ec37aa7so332717739f.0
        for <kvm@vger.kernel.org>; Mon, 11 Sep 2023 11:44:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694457873; x=1695062673;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ovvc9S0M0fusmEOptIxpRYf51VbT2wJC8z+64gwHvT4=;
        b=wb5vQfP2u4KKshZ4/JDvV6voyQJI1ffXCbZ0JD6Rdc0MDpy7eMLaYCKt5AmuW+4+FP
         cVj4jK6lCwE2CcQz93NKbSa746eRNOmta5w7QVdEd6ykWsMoqoG+NNSpaPK0gqd+snlP
         IuodWbEa4TGhEqmY4p2o46iA34wUuZsxzekD/D0j9PkF2dv/4YqYZZiw5dkmD/wbBeKV
         nMytCwk7L5YA2s04LG851C65jgO3DdwlCcN/Op1Uxkwfy7K9NDt64gXVJB3FRUv1Pu7r
         0az/ZEYQgi82P4M3LWNTqUKDn7z6bSQ0g0aXkMlD4HfTFXK2UDYEJEKCKJWmHG/TbC3U
         I9ag==
X-Gm-Message-State: AOJu0Yz4mn8oXtSUPpBrhh8Vz0R/tv8jxAdpqcORnCcM9juq0lxRZLl7
        VMIb25xB4l5q2471TDENbfR/LfIJIUSti3bw55eVpybgzxXf4PA7gUdbJiZiDIj1LyeBwzCmnn8
        nlxnWndeobPxT
X-Received: by 2002:a5e:9247:0:b0:792:792e:6616 with SMTP id z7-20020a5e9247000000b00792792e6616mr13444916iop.2.1694457873027;
        Mon, 11 Sep 2023 11:44:33 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH5Ns8CF+cguv9IZKBefa7dViaNzCR4oy3BIhvny7IeDcQ2kl9cZDg3xsSJu4ZrwfVj50Pzow==
X-Received: by 2002:a5e:9247:0:b0:792:792e:6616 with SMTP id z7-20020a5e9247000000b00792792e6616mr13444905iop.2.1694457872775;
        Mon, 11 Sep 2023 11:44:32 -0700 (PDT)
Received: from redhat.com ([38.15.60.12])
        by smtp.gmail.com with ESMTPSA id g12-20020a0566380c4c00b004290f6c15bfsm2319678jal.145.2023.09.11.11.44.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Sep 2023 11:44:32 -0700 (PDT)
Date:   Mon, 11 Sep 2023 12:44:31 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Cong Liu <liucong2@kylinos.cn>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fix build error in function vfio_combine_iova_ranges
Message-ID: <20230911124431.5e09f53b.alex.williamson@redhat.com>
In-Reply-To: <20230911094103.57771-1-liucong2@kylinos.cn>
References: <20230911094103.57771-1-liucong2@kylinos.cn>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.35; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 11 Sep 2023 17:41:02 +0800
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
>  drivers/vfio/vfio_main.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
> index 40732e8ed4c6..0a9620409696 100644
> --- a/drivers/vfio/vfio_main.c
> +++ b/drivers/vfio/vfio_main.c
> @@ -938,12 +938,13 @@ static int vfio_ioctl_device_feature_migration(struct vfio_device *device,
>  void vfio_combine_iova_ranges(struct rb_root_cached *root, u32 cur_nodes,
>  			      u32 req_nodes)
>  {
> -	struct interval_tree_node *prev, *curr, *comb_start, *comb_end;
> +	struct interval_tree_node *prev, *curr;
> +	struct interval_tree_node *comb_start, *comb_end;

This looks cosmetic, what did it fix?  It's not clear to me how any of
this addresses the last two errors.  Thanks,

Alex

>  	unsigned long min_gap, curr_gap;
>  
>  	/* Special shortcut when a single range is required */
>  	if (req_nodes == 1) {
> -		unsigned long last;
> +		unsigned long last = 0;
>  
>  		comb_start = interval_tree_iter_first(root, 0, ULONG_MAX);
>  		curr = comb_start;

