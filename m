Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4EBE876F389
	for <lists+kvm@lfdr.de>; Thu,  3 Aug 2023 21:39:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230353AbjHCTjL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Aug 2023 15:39:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229777AbjHCTjK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Aug 2023 15:39:10 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82C2C211B
        for <kvm@vger.kernel.org>; Thu,  3 Aug 2023 12:38:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1691091502;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=C8fBRKG84oTUzu4cJ0upEFkniwHWsF/Sd26+sDxvy08=;
        b=f5nC44nZhqLa4M0+ouux80jy1Am6JwhKbst0ntqMzKlEnulWgZWMKMdP0L5Lgv62Vfhtbk
        wATlmtD6dDFNRSOde/didtfsqNkcxez381b547K3bbdX83mfKcCxzOQ+Qc3tKkRx6jC8RH
        1Gc92rHnteugqw0Vjg3xX1KqVIvqL3Y=
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com
 [209.85.166.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-402-wxs8BS9cPeuVJgDu5o-now-1; Thu, 03 Aug 2023 15:38:21 -0400
X-MC-Unique: wxs8BS9cPeuVJgDu5o-now-1
Received: by mail-il1-f199.google.com with SMTP id e9e14a558f8ab-34631fd18beso11478705ab.0
        for <kvm@vger.kernel.org>; Thu, 03 Aug 2023 12:38:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691091500; x=1691696300;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=C8fBRKG84oTUzu4cJ0upEFkniwHWsF/Sd26+sDxvy08=;
        b=A1oj5+QJvBFTnnkMC7jEX6ieasnr430xfjzFGX+Rp1hu3f71Hg/LP3oYXVzt2AWrTz
         2tkGr2YTsdzhErsiUjmMmPhfPvYCpdug0PbeIBGxY6R3tamZ4cHFBQX/OQiieqHtrHVR
         LruKfadvSXT7Sg0O3hjnchVVNCC1g6IodTKYPKIZ5T2aFDa5SBoVLMLuOXDX4biv/Byh
         Fpd7C69sofRfHgG9KSOXYc0HeL+aHISs0yJKKakhiOX7S2XQX1QypQ/rFK5qWlfsUXOj
         c9fWGsQoGGwoHgC1j/sesSRRsHI6p7Mmw/7Gc/eDXdQLvOpxsDYidUDobh7NYrvIIQXh
         Qq3Q==
X-Gm-Message-State: ABy/qLY33EuTHlr6JkGFskyy7T5L//HPRIo35oXP4zQO2u6YxRKFsCEd
        vwD3y86oMT/Spzocx1zWVHSb01gMvOW3BpFoXt7PM8lh2+ZSxY1XNkj5vBxe8CEslX5j8fEBFC6
        Iehk9TOoGHevr
X-Received: by 2002:a92:d083:0:b0:349:19e:7656 with SMTP id h3-20020a92d083000000b00349019e7656mr13385731ilh.28.1691091500566;
        Thu, 03 Aug 2023 12:38:20 -0700 (PDT)
X-Google-Smtp-Source: APBJJlFozrDPoA3AZ5UQWG5fcKBYQDbRoiwLlBgBEKUdt19LvvvypUn54PZ7JdYNXseH/zc0WqTLYA==
X-Received: by 2002:a92:d083:0:b0:349:19e:7656 with SMTP id h3-20020a92d083000000b00349019e7656mr13385718ilh.28.1691091500314;
        Thu, 03 Aug 2023 12:38:20 -0700 (PDT)
Received: from redhat.com ([38.15.60.12])
        by smtp.gmail.com with ESMTPSA id t7-20020a92cc47000000b00345d6e8ded4sm176994ilq.25.2023.08.03.12.38.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Aug 2023 12:38:19 -0700 (PDT)
Date:   Thu, 3 Aug 2023 13:38:12 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Sean Christopherson <seanjc@google.com>,
        Roxana Bradescu <roxabee@google.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/2] kvm/vfio: ensure kvg instance stays around in
 kvm_vfio_group_add()
Message-ID: <20230803133812.491956b9.alex.williamson@redhat.com>
In-Reply-To: <20230714224538.404793-1-dmitry.torokhov@gmail.com>
References: <20230714224538.404793-1-dmitry.torokhov@gmail.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 14 Jul 2023 15:45:32 -0700
Dmitry Torokhov <dmitry.torokhov@gmail.com> wrote:

> kvm_vfio_group_add() creates kvg instance, links it to kv->group_list,
> and calls kvm_vfio_file_set_kvm() with kvg->file as an argument after
> dropping kv->lock. If we race group addition and deletion calls, kvg
> instance may get freed by the time we get around to calling
> kvm_vfio_file_set_kvm().
> 
> Previous iterations of the code did not reference kvg->file outside of
> the critical section, but used a temporary variable. Still, they had
> similar problem of the file reference being owned by kvg structure and
> potential for kvm_vfio_group_del() dropping it before
> kvm_vfio_group_add() had a chance to complete.
> 
> Fix this by moving call to kvm_vfio_file_set_kvm() under the protection
> of kv->lock. We already call it while holding the same lock when vfio
> group is being deleted, so it should be safe here as well.
> 
> Fixes: 2fc1bec15883 ("kvm: set/clear kvm to/from vfio_group when group add/delete")
> Reviewed-by: Alex Williamson <alex.williamson@redhat.com>
> Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> ---

Applied series to vfio next branch for v6.6.  There's a minor rebase
involved, so please double check the results:

https://github.com/awilliam/linux-vfio/commits/next

Thanks,
Alex

> 
> v3: added Alex's reviewed-by
> 
> v2: updated commit description with the correct "Fixes" tag (per Alex),
>     expanded commit description to mention issues with the earlier
>     implementation of kvm_vfio_group_add().
> 
>  virt/kvm/vfio.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/virt/kvm/vfio.c b/virt/kvm/vfio.c
> index 9584eb57e0ed..cd46d7ef98d6 100644
> --- a/virt/kvm/vfio.c
> +++ b/virt/kvm/vfio.c
> @@ -179,10 +179,10 @@ static int kvm_vfio_group_add(struct kvm_device *dev, unsigned int fd)
>  	list_add_tail(&kvg->node, &kv->group_list);
>  
>  	kvm_arch_start_assignment(dev->kvm);
> +	kvm_vfio_file_set_kvm(kvg->file, dev->kvm);
>  
>  	mutex_unlock(&kv->lock);
>  
> -	kvm_vfio_file_set_kvm(kvg->file, dev->kvm);
>  	kvm_vfio_update_coherency(dev);
>  
>  	return 0;

