Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61C444CAA2A
	for <lists+kvm@lfdr.de>; Wed,  2 Mar 2022 17:29:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241968AbiCBQ34 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Mar 2022 11:29:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237912AbiCBQ3x (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Mar 2022 11:29:53 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 95C0840E48
        for <kvm@vger.kernel.org>; Wed,  2 Mar 2022 08:29:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646238548;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=4JYBVP71dm6qwHu1wwd1S6iPhE9b42/h7o81Qtmexmg=;
        b=SwVehJPL31yFdAh2MMoLz/v8nHvs2H48IBFxaNoXUO4qQtazu0igoeH4fFgIdDZGr9Dcvp
        d73PKZwVhNjVtzYNvlk5Z4ZowsVmcxIs7oPedPzo3UWPcJ/D0runLsoR6Bg1LZ7qvqXAN9
        xUX9tF5UqN6EB5czkXFp7RY9QjechII=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-245-QoJc933LMUKgRoz38rTTLQ-1; Wed, 02 Mar 2022 11:29:07 -0500
X-MC-Unique: QoJc933LMUKgRoz38rTTLQ-1
Received: by mail-wr1-f70.google.com with SMTP id o9-20020adfca09000000b001ea79f7edf8so822465wrh.16
        for <kvm@vger.kernel.org>; Wed, 02 Mar 2022 08:29:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=4JYBVP71dm6qwHu1wwd1S6iPhE9b42/h7o81Qtmexmg=;
        b=6fgGiUa6vmCXg39HCTShJYaJrNEAAj+9frZEZ95BPMsXsYk76UmArflOQFhQCSOTsr
         JsLsBZVAWYVjAt1nbyPN3lN2JdI1aHHrLObxkg4Tain8ma0fcird2QPcxExoOAtfRSdh
         WhF81qvstg6+bwBaNNjReDDWNYjiEU+Fn8MpjHUH/ctxFM0/YkBdp1+9E08Xp/e9xd1L
         AJEGOw12CcMYt4GcIkHMIYLEn440AdBbv46j2yJOE8Tu1FCg9dFIbuJGXi5V4rzp6HOZ
         /EkGJluX1xn6+vuUNrMSNjgjyhvpsl59WPn8dkGfgs60jDI8QTMukylqZYcJR41q/1zp
         bU7A==
X-Gm-Message-State: AOAM532kBJz/v1ytJZoaMAlwrJAJrtVimzAVo9v7RxXlt1nnqC5UpfuC
        2PPjIExTieKxTJ15GuSton9LEG3xRNd57OSQqGoGzpHTPVBIElIvEMkwQLzc5ZYn3G1yfCUWU/P
        N1zki8p+Tk0cc
X-Received: by 2002:a5d:56cd:0:b0:1ee:3248:525b with SMTP id m13-20020a5d56cd000000b001ee3248525bmr21677352wrw.124.1646238546598;
        Wed, 02 Mar 2022 08:29:06 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwnuzpoqkxUXsedIQ3mO7DVJwgzjOmZC8iKKjQtEy+lCllqu+K+PPeU8AEGxPiyGzG6Giw9Sw==
X-Received: by 2002:a5d:56cd:0:b0:1ee:3248:525b with SMTP id m13-20020a5d56cd000000b001ee3248525bmr21677329wrw.124.1646238546364;
        Wed, 02 Mar 2022 08:29:06 -0800 (PST)
Received: from redhat.com ([2a10:8006:355c:0:48d6:b937:2fb9:b7de])
        by smtp.gmail.com with ESMTPSA id m18-20020a5d56d2000000b001edc00dbeeasm16594955wrw.69.2022.03.02.08.29.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Mar 2022 08:29:05 -0800 (PST)
Date:   Wed, 2 Mar 2022 11:29:02 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     Laszlo Ersek <lersek@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>,
        QEMU Developers <qemu-devel@nongnu.org>,
        linux-hyperv@vger.kernel.org,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Alexander Graf <graf@amazon.com>,
        "Michael Kelley (LINUX)" <mikelley@microsoft.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        adrian@parity.io,
        Daniel =?iso-8859-1?Q?P=2E_Berrang=E9?= <berrange@redhat.com>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Jann Horn <jannh@google.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        "Brown, Len" <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        Linux PM <linux-pm@vger.kernel.org>,
        Colm MacCarthaigh <colmmacc@amazon.com>,
        Theodore Ts'o <tytso@mit.edu>, Arnd Bergmann <arnd@arndb.de>
Subject: Re: propagating vmgenid outward and upward
Message-ID: <20220302112258-mutt-send-email-mst@kernel.org>
References: <20220301121419-mutt-send-email-mst@kernel.org>
 <CAHmME9qieLUDVoPYZPo=N8NCL1T-RzQ4p7kCFv3PKFUkhWZPsw@mail.gmail.com>
 <20220302031738-mutt-send-email-mst@kernel.org>
 <CAHmME9pf-bjnZuweoLqoFEmPy1OK7ogEgGEAva1T8uVTufhCuw@mail.gmail.com>
 <20220302074503-mutt-send-email-mst@kernel.org>
 <Yh93UZMQSYCe2LQ7@zx2c4.com>
 <20220302092149-mutt-send-email-mst@kernel.org>
 <CAHmME9rf7hQP78kReP2diWNeX=obPem=f8R-dC7Wkpic2xmffg@mail.gmail.com>
 <20220302101602-mutt-send-email-mst@kernel.org>
 <Yh+PET49oHNpxn+H@zx2c4.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yh+PET49oHNpxn+H@zx2c4.com>
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 02, 2022 at 04:36:49PM +0100, Jason A. Donenfeld wrote:
> Hi Michael,
> 
> On Wed, Mar 02, 2022 at 10:20:25AM -0500, Michael S. Tsirkin wrote:
> > So writing some code:
> > 
> > 1:
> > 	put plaintext in a buffer
> > 	put a key in a buffer
> > 	put the nonce for that encryption in a buffer
> > 
> > 	if vm gen id != stored vm gen id
> > 		stored vm gen id = vm gen id
> > 		goto 1
> > 
> > I think this is race free, but I don't see why does it matter whether we
> > read gen id atomically or not.
> 
> Because that 16 byte read of vmgenid is not atomic. Let's say you read
> the first 8 bytes, and then the VM is forked. In the forked VM, the next
> 8 bytes are the same as last time, but the first 8 bytes, which you
> already read, have changed. In that case, your != becomes a ==, and the
> test fails.
> 
> This is one of those fundamental things of "unique ID" vs "generation
> counter word".
> 
> Anyway, per your request in your last email, I wrote some code for this,
> which may or may not be totally broken, and only works on 64-bit x86,
> which is really the best possible case in terms of performance. And even
> so, it's not great.
> 
> Jason
> 
> --------8<------------------------
> 
> diff --git a/drivers/net/wireguard/noise.c b/drivers/net/wireguard/noise.c
> index 720952b92e78..250b8973007d 100644
> --- a/drivers/net/wireguard/noise.c
> +++ b/drivers/net/wireguard/noise.c
> @@ -106,6 +106,7 @@ static struct noise_keypair *keypair_create(struct wg_peer *peer)
>  	keypair->entry.type = INDEX_HASHTABLE_KEYPAIR;
>  	keypair->entry.peer = peer;
>  	kref_init(&keypair->refcount);
> +	keypair->vmgenid = vmgenid_read_atomic();
>  	return keypair;
>  }
> 
> diff --git a/drivers/net/wireguard/noise.h b/drivers/net/wireguard/noise.h
> index c527253dba80..0add240a14a0 100644
> --- a/drivers/net/wireguard/noise.h
> +++ b/drivers/net/wireguard/noise.h
> @@ -27,10 +27,13 @@ struct noise_symmetric_key {
>  	bool is_valid;
>  };
> 
> +extern __uint128_t vmgenid_read_atomic(void);
> +
>  struct noise_keypair {
>  	struct index_hashtable_entry entry;
>  	struct noise_symmetric_key sending;
>  	atomic64_t sending_counter;
> +	__uint128_t vmgenid;
>  	struct noise_symmetric_key receiving;
>  	struct noise_replay_counter receiving_counter;
>  	__le32 remote_index;
> diff --git a/drivers/net/wireguard/send.c b/drivers/net/wireguard/send.c
> index 5368f7c35b4b..40d016be59e3 100644
> --- a/drivers/net/wireguard/send.c
> +++ b/drivers/net/wireguard/send.c
> @@ -381,6 +381,9 @@ void wg_packet_send_staged_packets(struct wg_peer *peer)
>  			goto out_invalid;
>  	}
> 
> +	if (keypair->vmgenid != vmgenid_read_atomic())
> +		goto out_invalid;
> +
>  	packets.prev->next = NULL;
>  	wg_peer_get(keypair->entry.peer);
>  	PACKET_CB(packets.next)->keypair = keypair;

I don't think we care about an atomic read here.  All data is in buffer
by this point, if it did not fork before that then we are ok, even
if it forks during the read.

We probably do need a memory barrier to make sure all writes complete
before the read of vmgenid, I'm not sure which kind - I think hypervisor
can be trusted to do a full CPU barrier on fork so probably just a
compiler barrier.

> diff --git a/drivers/virt/vmgenid.c b/drivers/virt/vmgenid.c
> index 0ae1a39f2e28..c122fae1d494 100644
> --- a/drivers/virt/vmgenid.c
> +++ b/drivers/virt/vmgenid.c
> @@ -21,6 +21,21 @@ struct vmgenid_state {
>  	u8 this_id[VMGENID_SIZE];
>  };
> 
> +static __uint128_t *val;
> +
> +__uint128_t vmgenid_read_atomic(void)
> +{
> +	__uint128_t ret = 0;
> +	if (!val)
> +		return 0;
> +	asm volatile("lock cmpxchg16b %1"
> +		     : "+A"(ret)
> +		     : "m"(*val), "b"(0), "c"(0)
> +		     : "cc");
> +	return ret;
> +}
> +EXPORT_SYMBOL(vmgenid_read_atomic);
> +
>  static int vmgenid_add(struct acpi_device *device)
>  {
>  	struct acpi_buffer parsed = { ACPI_ALLOCATE_BUFFER };
> @@ -50,6 +65,7 @@ static int vmgenid_add(struct acpi_device *device)
>  	phys_addr = (obj->package.elements[0].integer.value << 0) |
>  		    (obj->package.elements[1].integer.value << 32);
>  	state->next_id = devm_memremap(&device->dev, phys_addr, VMGENID_SIZE, MEMREMAP_WB);
> +	val = (__uint128_t *)state->next_id;
>  	if (IS_ERR(state->next_id)) {
>  		ret = PTR_ERR(state->next_id);
>  		goto out;

