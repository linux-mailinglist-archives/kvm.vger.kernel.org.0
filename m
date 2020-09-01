Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DB3925985D
	for <lists+kvm@lfdr.de>; Tue,  1 Sep 2020 18:26:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731860AbgIAQZ5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Sep 2020 12:25:57 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:23376 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1732083AbgIAQZv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Sep 2020 12:25:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1598977550;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=02QkjKG1ciVZ/SZ1+fSg/UxfgUofnVY9E0gaoJNRSe8=;
        b=Z714eEeB82E3pQf2DqnrmDZ3EjX4Ue8oYMhZs4IKwfnPJcPLd03BuknMy7eGD/xsPyKx9i
        lwVzC8hhtnAmCmvv7LtU0VUzk2nwgO2kHlcCsBuBfjv/4h/ukefxIXVxjlsT5KswF4AsL3
        1WQMH+4rqzugNHDdxP4rXCn3wuxJd4E=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-391-rk76fVWmMOy8sP2L9sIy4g-1; Tue, 01 Sep 2020 12:25:46 -0400
X-MC-Unique: rk76fVWmMOy8sP2L9sIy4g-1
Received: by mail-wr1-f72.google.com with SMTP id e14so779670wrr.7
        for <kvm@vger.kernel.org>; Tue, 01 Sep 2020 09:25:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=02QkjKG1ciVZ/SZ1+fSg/UxfgUofnVY9E0gaoJNRSe8=;
        b=fpUNiT7kIvq9BoClKZ/LC1Gx2/mIluba3YjR7jezssW+D3QcjnQ1SHMBJa/bcsCg1p
         b1uPTUALhAqS3utzjCSCbVVzy9yvcj4hWz/1TTIjkRkswh2KS68rYXhvpXX6zssMWvGd
         Lfbfa3fgGhzOQ1wvhmiKYb+FiNGWvpaOdt74OCj4ND9QxF6BlkqYTvAaPwxvgVE9aLR0
         qVN3tDqdYRacU8t2LRIfiF6rqhhH1Z6pX4x/JuLfU04O2rNHo5W+Wf/SiLoL1dGXXEim
         OjdqYB1UnlNvKROpVDGy9RWebqIbdJn9GbcP88uXbexG2P39Ea5LVGXYocUYJR+Dv+jH
         8dug==
X-Gm-Message-State: AOAM532ziTU3MEWCpcFblHIqRVtUazvOzZP/ePNaLVCHGPMdbLv6wtfP
        VkRUbTp75jImPGN59XGPaYf4P7N/u83TBWBghVpVNiqUwow8BUMG5MsNydbaPYJubyuuQA3HyUz
        uoRF77+s1b99s
X-Received: by 2002:adf:e8c3:: with SMTP id k3mr2794204wrn.228.1598977544740;
        Tue, 01 Sep 2020 09:25:44 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwZBwMu9jEZcrJ5aoeYibQLoi7inHjh994XlsUOFj/MJ/rDb4MiJy+fC4tFpUaP66vXk9YJmg==
X-Received: by 2002:adf:e8c3:: with SMTP id k3mr2794187wrn.228.1598977544552;
        Tue, 01 Sep 2020 09:25:44 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id d11sm3116525wrw.77.2020.09.01.09.25.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Sep 2020 09:25:43 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Rustam Kovhaev <rkovhaev@gmail.com>
Cc:     linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        pbonzini@redhat.com, kvm@vger.kernel.org
Subject: Re: [PATCH] KVM: fix memory leak in kvm_io_bus_unregister_dev()
In-Reply-To: <20200830043405.268044-1-rkovhaev@gmail.com>
References: <20200830043405.268044-1-rkovhaev@gmail.com>
Date:   Tue, 01 Sep 2020 18:25:42 +0200
Message-ID: <877dtdwjjt.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Rustam Kovhaev <rkovhaev@gmail.com> writes:

> when kmalloc() fails in kvm_io_bus_unregister_dev(), before removing
> the bus, we should iterate over all other devices linked to it and call
> kvm_iodevice_destructor() for them
>
> Reported-and-tested-by: syzbot+f196caa45793d6374707@syzkaller.appspotmail.com
> Link: https://syzkaller.appspot.com/bug?extid=f196caa45793d6374707
> Signed-off-by: Rustam Kovhaev <rkovhaev@gmail.com>
> ---
>  virt/kvm/kvm_main.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
>
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 67cd0b88a6b6..646aa7b82548 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -4332,7 +4332,7 @@ int kvm_io_bus_register_dev(struct kvm *kvm, enum kvm_bus bus_idx, gpa_t addr,
>  void kvm_io_bus_unregister_dev(struct kvm *kvm, enum kvm_bus bus_idx,
>  			       struct kvm_io_device *dev)
>  {
> -	int i;
> +	int i, j;
>  	struct kvm_io_bus *new_bus, *bus;
>  
>  	bus = kvm_get_bus(kvm, bus_idx);
> @@ -4351,6 +4351,11 @@ void kvm_io_bus_unregister_dev(struct kvm *kvm, enum kvm_bus bus_idx,
>  			  GFP_KERNEL_ACCOUNT);
>  	if (!new_bus)  {
                     ^^^ redundant space 

>  		pr_err("kvm: failed to shrink bus, removing it completely\n");
> +		for (j = 0; j < bus->dev_count; j++) {
> +			if (j == i)
> +				continue;
> +			kvm_iodevice_destructor(bus->range[j].dev);
> +		}
>  		goto broken;

The name of the label is really misleading (as it is not actually a
failure path), I'd even suggest we get rid of this goto completely,
something like

	new_bus = kmalloc(struct_size(bus, range, bus->dev_count - 1),
			  GFP_KERNEL_ACCOUNT);
	if (new_bus)  {
	       memcpy(new_bus, bus, sizeof(*bus) + i * sizeof(struct kvm_io_range));
	       new_bus->dev_count--;
	       memcpy(new_bus->range + i, bus->range + i + 1,
	              (new_bus->dev_count - i) * sizeof(struct kvm_io_range));
        } else {
		pr_err("kvm: failed to shrink bus, removing it completely\n");
		for (j = 0; j < bus->dev_count; j++) {
			if (j == i)
				continue;
			kvm_iodevice_destructor(bus->range[j].dev);
	}

	rcu_assign_pointer(kvm->buses[bus_idx], new_bus);
	synchronize_srcu_expedited(&kvm->srcu);
	kfree(bus);
	return;


>  	}

None of the above should block the fix IMO, so:

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

-- 
Vitaly

