Return-Path: <kvm+bounces-20844-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7B29C923AC4
	for <lists+kvm@lfdr.de>; Tue,  2 Jul 2024 11:54:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 409EC2815F7
	for <lists+kvm@lfdr.de>; Tue,  2 Jul 2024 09:54:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 04D681581E1;
	Tue,  2 Jul 2024 09:53:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="e6f/Ifp7"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B192156C6C
	for <kvm@vger.kernel.org>; Tue,  2 Jul 2024 09:53:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719914026; cv=none; b=WXFWyIANGkkYjDP3ccm2HC0L9WIkHdILyjTotqgbU5zYPLfP1C93g7wRsnZN5O6SOqD50rBtqfwm8fhPkDuRYq5Ap+U7uiuOxzfm+vEiLx2nUDDYVw16hvK5jDHA5x7kEoPM+swieD9xPYZ1C8vIyrVFDHy/h5UkuxXkHpHG4k0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719914026; c=relaxed/simple;
	bh=MGSzto/cq3LB0E4ecOkYu6NC/5l/m8jXuofARCe6LEA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NzQNUsnMsFAPrKRiD2yMyBUW41vM54U1kgRI2MgpAyS6ul9QLaHQt6WplXHdFUN606iIDeWrH8lWk1oWI+A8r5WsA9/CiqNHrLUq0Q4QJGt5RZe/feboughAoMqRNk+SpOIklWWL++3um0r56Hqb404dVTQsRD/deYMqnet3J9E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=e6f/Ifp7; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1719914023;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=7gbuCbmqaQOZCH0Y2TLfMh3O6y0nrrvSpYLO6jxz61g=;
	b=e6f/Ifp7jlzzh41vq7u3vObNxyu/9SP7bzKi5vQ9ZHvnrwv2YsStcK3bedVWD53Snahimp
	gqz8mxEg9L49fI1YgE2c/KckNRctwuzNfpSsX6NuL108SSEKIsLK/PeUf/M6ZzV8PwzXcQ
	NLTTbPcJHDSeZK1EF+X3UrbjqWVg5xo=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-373-pU4vVqxaP-iGlbu6tsaemA-1; Tue, 02 Jul 2024 05:53:40 -0400
X-MC-Unique: pU4vVqxaP-iGlbu6tsaemA-1
Received: by mail-qt1-f199.google.com with SMTP id d75a77b69052e-4464caaa6f2so56518891cf.3
        for <kvm@vger.kernel.org>; Tue, 02 Jul 2024 02:53:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719914020; x=1720518820;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7gbuCbmqaQOZCH0Y2TLfMh3O6y0nrrvSpYLO6jxz61g=;
        b=nkVWk+kbOVysZVtqEyybxQx8ywG9fjxrhJSR1iQiYwr6wN3RFjBWAPb1EuelLU/gxY
         43thhWA7M4+3ZSVaLLa89iDk3QVaBvcAYq/gD3MHQa8pKPThN/5l6o/gU62bn+XUE2Cm
         +7sxyP0nbQdzDLgqM1UCgA8Z4kbwELmKB+/sXRgYCiEH+Ui1WdqAQ+1Qjo2nwFalu+Hz
         8xKhcvCjiD46dCTJs6njKEIf5gB0Wfz13EEw6MLiqou0XLWobvKU53N0TX4Rl5Affo4n
         uFsCdfc7TSYvL3ny8u5eG2RTZTdoR4y5CjGpOakl2y4l7ogkfthDoeM0S5UMZMkx+w0C
         HVBg==
X-Forwarded-Encrypted: i=1; AJvYcCV/L6QdFJhwHEGEKl80BY9bbPgUUVw3CJFYfg/unlaF5PPdjkuud7Xxv3w23LhDDpm48eVPspixWOkM6MxkjqOMJXN5
X-Gm-Message-State: AOJu0YwoEjnxVErqLMMlLsoIMoHUqFwDgyehAe2mURAJ99bjcyiK0+8R
	3EE+31TkNBsYXAngX6oYS9GqCFMzW9G8K7C4RNUTuZbIGrq5kTeTZlSXIEuBJ22faxEIPg6nPQA
	2x6CeE3xjU3X1J1qOZMoYCveAbNBSNXHU71+9am50SqC7voyV8Q==
X-Received: by 2002:a05:622a:1a9b:b0:43a:ac99:4bb5 with SMTP id d75a77b69052e-44662e9743cmr109715681cf.51.1719914020144;
        Tue, 02 Jul 2024 02:53:40 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHCcQNmIPoKc5Qmxn92R19gzUW4REeysnZ+oNphjyAhLmalfFvXnVJlo/R+c80Iq9xcgNw8ug==
X-Received: by 2002:a05:622a:1a9b:b0:43a:ac99:4bb5 with SMTP id d75a77b69052e-44662e9743cmr109715461cf.51.1719914019651;
        Tue, 02 Jul 2024 02:53:39 -0700 (PDT)
Received: from sgarzare-redhat ([193.207.133.110])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-446514b2484sm39462531cf.81.2024.07.02.02.53.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Jul 2024 02:53:39 -0700 (PDT)
Date: Tue, 2 Jul 2024 11:53:30 +0200
From: Stefano Garzarella <sgarzare@redhat.com>
To: Luigi Leonardi <luigi.leonardi@outlook.com>
Cc: devnull+luigi.leonardi.outlook.com@kernel.org, davem@davemloft.net, 
	edumazet@google.com, kuba@kernel.org, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, marco.pinn95@gmail.com, netdev@vger.kernel.org, 
	pabeni@redhat.com, stefanha@redhat.com, virtualization@lists.linux.dev
Subject: Re: [PATCH PATCH net-next v2 2/2] vsock/virtio: avoid enqueue
 packets when work queue is empty
Message-ID: <e52cj2hjqmx5egtvnkqua3fvgiggfwcmkcsw3zswbey5s4bc4p@qp3togqfwgol>
References: <20240701-pinna-v2-2-ac396d181f59@outlook.com>
 <AS2P194MB21701DDDFD9714671737D0E39AD32@AS2P194MB2170.EURP194.PROD.OUTLOOK.COM>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <AS2P194MB21701DDDFD9714671737D0E39AD32@AS2P194MB2170.EURP194.PROD.OUTLOOK.COM>

On Mon, Jul 01, 2024 at 04:49:41PM GMT, Luigi Leonardi wrote:
>Hi all,
>
>> +		/* Inside RCU, can't sleep! */
>> +		ret = mutex_trylock(&vsock->tx_lock);
>> +		if (unlikely(ret == 0))
>> +			goto out_worker;
>
>I just realized that here I don't release the tx_lock and
>that the email subject is "PATCH PATCH".
>I will fix this in the next version.

What about adding a function to handle all these steps?
So we can handle better the error path in this block code.

IMHO to simplify the code, you can just return true or false if you 
queued it. Then if the driver is disappearing and we are still queuing 
it, it will be the release that will clean up all the queues, so we 
might not worry about this edge case.

Thanks,
Stefano

>Any feedback is welcome!
>
>Thanks,
>Luigi
>


