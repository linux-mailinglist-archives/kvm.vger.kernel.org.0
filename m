Return-Path: <kvm+bounces-16503-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 85A1A8BAC8D
	for <lists+kvm@lfdr.de>; Fri,  3 May 2024 14:34:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3E60B28277D
	for <lists+kvm@lfdr.de>; Fri,  3 May 2024 12:34:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3A85525765;
	Fri,  3 May 2024 12:34:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="iQLK5e8u"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98590441F
	for <kvm@vger.kernel.org>; Fri,  3 May 2024 12:34:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714739646; cv=none; b=alrF9GfDYWcywuQY0EhQorxiRL8JJ9fb737WK+jKbfs6Ea/z7V8MCEFvY92Fu/IFriAE9DwnEl+OOwhlV+1z9F7MHgw9jTqmHabkSd9WUMZhUB5HO8Ylt6BoFYq591xkn0zQ5VmK0sKoargzd1H84qD9BczxdX7NghjeKwQCEd4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714739646; c=relaxed/simple;
	bh=G/zVUxlEWcNKwm+znnDGsaqOjjz8DvKCMitycXD7VYc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=o3EhAuxGcBR026SURI8TecyekWHE7/sWft9A5IK5IodgvNVzajKoRZr+I3nDUKWx2g9mSwMb15o4Byvwz9af8Zw6PTHlvveRO0aX226pNIHYYcbUS/lmottN0cszLjPfSHptCh4C6yGBKl1PgBtfyqxWEnWh+J9VroUAW/mgO8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=iQLK5e8u; arc=none smtp.client-ip=209.85.218.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-a59954c1271so131900166b.3
        for <kvm@vger.kernel.org>; Fri, 03 May 2024 05:34:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1714739643; x=1715344443; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=PqLmK69BsFys4BXQpEqqpShQjibb6+oR2+a8gTQ0k/c=;
        b=iQLK5e8uX6tDAri+w1blIQffhZcJn1wVCsJQ2mwhUM0Qa5zHMtgXvxQDs+lC+ujy6s
         thKHdUpMBZgmws1k4x2OPwz7MCuvOhIx3VbKAuvB/wMUI9qGXDwA34zR7q/3bjsvG9jc
         vLMU+IOdEYHlYf9qeptbg0qZsG+AWvhmPtml8+fJ4cDK57ewlqBR4C57tCZHly7EXFXf
         V0NRkQK1Sv/3pPwDzpQIvaVMwAcQuten/GNhDFdBtyJRIGNakyIZLsG91GKpIF0LfzHG
         EZwYeh4HPDwQuFS4gc6CQi7nAX8sDqi8DUGhIJ504YHfeIY5leRS/h6aiS6788dseXFd
         ZNBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714739643; x=1715344443;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PqLmK69BsFys4BXQpEqqpShQjibb6+oR2+a8gTQ0k/c=;
        b=HGi2v3g7uTNWkPaCoN3DW4idrPzjDFVuy0yG4TrAcub4FyyHq6mwCI1XBhGW9nfJBB
         ByICGYlVPHgxwXTE09MiitnshOkmuWkIg71iIiXnmMEFyhgx8UEcSp3LteBCm0yNV9eb
         jX+98ojDtpF9fUBLItjwuHWlmzZ5Kf2T6KlhIQ4sjlbDPisLidYeNT1XwgmzTZy2rfBQ
         30kyZMetxLJ6RUZbRpaLObrSKmObnC9rg7CLGYNlLH8j/JmKNxIH4TrJXkw6IzEg3eTD
         p3hPIp378LF7Ixzd3cqpwShhVSAZcd8K836Uw1/bKBFj4CfEVVJr7Zn5duQ4vNyIEVM/
         8gRg==
X-Forwarded-Encrypted: i=1; AJvYcCW3sXyNG4AFgAL0qKFthFGNgSwMl9wsJsJb2zyRQYLiV+brhhIC/g76AatjZXA9Fa9RjOeAfHFbP6EMQKN7BoOO2SS3
X-Gm-Message-State: AOJu0Yy831X+Imwp1HTXhHc0cO8C6M5qJi1Jff+zxQtQqasyXtE4jvHQ
	Rtb33LpXW8j3OqJWW+C0ZTcIHjsJt9HQOi0hzVVWmjOxP3FSkXT/RQI7q93ys0YzFNKU9mgWqj0
	xaA0lw2JrVUCiikztv9ZZuiIUrSnJTG4BAynKkw==
X-Google-Smtp-Source: AGHT+IGfceQxov+mMFmgsCI+0u2WDScpMl0s6robO8RLQBd9P7td6ades1yvgaZrBARkASf5Fh26e1FLvAFxdsrpZtg=
X-Received: by 2002:a50:99d8:0:b0:56e:24a5:587a with SMTP id
 n24-20020a5099d8000000b0056e24a5587amr1671836edb.11.1714739643003; Fri, 03
 May 2024 05:34:03 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230515160506.1776883-1-stefanha@redhat.com> <20230515160506.1776883-4-stefanha@redhat.com>
In-Reply-To: <20230515160506.1776883-4-stefanha@redhat.com>
From: Peter Maydell <peter.maydell@linaro.org>
Date: Fri, 3 May 2024 13:33:51 +0100
Message-ID: <CAFEAcA9U8jtHFYY1xZ69=PoR1imgzrTB9aK5aoe+vZJtQrU1Jg@mail.gmail.com>
Subject: Re: [PULL v2 03/16] block/block-backend: add block layer APIs
 resembling Linux ZonedBlockDevice ioctls
To: Stefan Hajnoczi <stefanha@redhat.com>
Cc: qemu-devel@nongnu.org, Richard Henderson <rth@twiddle.net>, 
	Paolo Bonzini <pbonzini@redhat.com>, Thomas Huth <thuth@redhat.com>, 
	=?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>, 
	Julia Suvorova <jusual@redhat.com>, Aarushi Mehta <mehta.aaru20@gmail.com>, 
	Kevin Wolf <kwolf@redhat.com>, kvm@vger.kernel.org, 
	=?UTF-8?B?TWFyYy1BbmRyw6kgTHVyZWF1?= <marcandre.lureau@redhat.com>, 
	Markus Armbruster <armbru@redhat.com>, Cornelia Huck <cohuck@redhat.com>, 
	Raphael Norwitz <raphael.norwitz@nutanix.com>, qemu-block@nongnu.org, 
	"Michael S. Tsirkin" <mst@redhat.com>, =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= <philmd@linaro.org>, 
	Hanna Reitz <hreitz@redhat.com>, Eric Blake <eblake@redhat.com>, 
	Stefano Garzarella <sgarzare@redhat.com>, Fam Zheng <fam@euphon.net>, Sam Li <faithilikerun@gmail.com>, 
	Hannes Reinecke <hare@suse.de>, Dmitry Fomichev <dmitry.fomichev@wdc.com>
Content-Type: text/plain; charset="UTF-8"

On Mon, 15 May 2023 at 17:07, Stefan Hajnoczi <stefanha@redhat.com> wrote:
>
> From: Sam Li <faithilikerun@gmail.com>
>
> Add zoned device option to host_device BlockDriver. It will be presented only
> for zoned host block devices. By adding zone management operations to the
> host_block_device BlockDriver, users can use the new block layer APIs
> including Report Zone and four zone management operations
> (open, close, finish, reset, reset_all).
>
> Qemu-io uses the new APIs to perform zoned storage commands of the device:
> zone_report(zrp), zone_open(zo), zone_close(zc), zone_reset(zrs),
> zone_finish(zf).
>
> For example, to test zone_report, use following command:
> $ ./build/qemu-io --image-opts -n driver=host_device, filename=/dev/nullb0
> -c "zrp offset nr_zones"

Hi; Coverity points out an issue in this commit (CID 1544771):

> +static int zone_report_f(BlockBackend *blk, int argc, char **argv)
> +{
> +    int ret;
> +    int64_t offset;
> +    unsigned int nr_zones;
> +
> +    ++optind;
> +    offset = cvtnum(argv[optind]);
> +    ++optind;
> +    nr_zones = cvtnum(argv[optind]);

cvtnum() can fail and return a negative value on error
(e.g. if the number in the string is out of range),
but we are not checking for that. Instead we stuff
the value into an 'unsigned int' and then pass that to
g_new(), which will result in our trying to allocate a large
amount of memory.

Here, and also in the other functions below that use cvtnum(),
I think we should follow the pattern for use of that function
that is used in the pre-existing code in this function:

 int64_t foo; /* NB: not an unsigned or some smaller type */

 foo = cvtnum(arg)
 if (foo < 0) {
     print_cvtnum_err(foo, arg);
     return foo; /* or otherwise handle returning an error upward */
 }

It looks like all the uses of cvtnum in this patch should be
adjusted to handle errors.

thanks
-- PMM

