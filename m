Return-Path: <kvm+bounces-2648-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E52817FBE7D
	for <lists+kvm@lfdr.de>; Tue, 28 Nov 2023 16:51:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6CC3DB2155F
	for <lists+kvm@lfdr.de>; Tue, 28 Nov 2023 15:51:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 529A01E4B5;
	Tue, 28 Nov 2023 15:51:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="g2FtqkKm"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 648E0D2
	for <kvm@vger.kernel.org>; Tue, 28 Nov 2023 07:51:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701186665;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=a7TaJ1fftDKYLjchnWgAH2T0JUqr3+5SdVc0/8Z4EIs=;
	b=g2FtqkKmMfVEwbeSWHRRRFzal+8CFPa2CspgBH++J3x8CMkl3YJhJAu3jTltdvmMAhlQoV
	cCu4wHUH7AEK3M9JNtwW1VAWHP6YrsgUpJwmRWvR3snPkgfqukHsMQGd1PM4QcgGLKOfJk
	gk7+Ls3r4CfWftxRqM3+qX9E775u0lI=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-695--hzQsYWNOxqwZpMk4tVzfg-1; Tue, 28 Nov 2023 10:51:04 -0500
X-MC-Unique: -hzQsYWNOxqwZpMk4tVzfg-1
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-a15ce298cf4so66044766b.1
        for <kvm@vger.kernel.org>; Tue, 28 Nov 2023 07:51:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701186663; x=1701791463;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=a7TaJ1fftDKYLjchnWgAH2T0JUqr3+5SdVc0/8Z4EIs=;
        b=KcrBtmz6L2MYGtiH6SFHf927jJYSvzwwSFdj7JVzyES7PUpIG7aHeJsqZongoTxA1w
         3GRRX5fZ/YwYveYKty1Onx0iEst0PZwH9DAP+SGSbia/osHiKBX5MRE7Pa0DEZv/aXV+
         LcAoeMjzsq0LZEF9J8CoSeVv5eBc/t/ovGTpuFTV4rqawSomNJUqY/zi8hf6ZlBWoBFj
         l7874tFDx9v4PjeQyKcMAU7dmvzRD0AfSBjAooHvuWHmhvxglQxuoUmEXsyMq/4I0oHP
         h3LRxFo+jrZfSRzzZWQRaxDnqIVu70CwTI/yfdazy1X+I2yOB5utqR3v9ecI4Jn+JQtQ
         5sRg==
X-Gm-Message-State: AOJu0Yxmz36Fxhaoa0FGsPGYJvwL3r62PQDHERw3b7Di0MQ1GTNNRTAe
	aMfhRps5K0jTr118btMyA9yW6hYOJlkiQzoWjKklZOQocEyUcMVJagiPp3elldqm74WZs7v8+ug
	So5GYojhpSeSk
X-Received: by 2002:a17:906:eb08:b0:9fd:5708:cefd with SMTP id mb8-20020a170906eb0800b009fd5708cefdmr10544135ejb.76.1701186662907;
        Tue, 28 Nov 2023 07:51:02 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEb0zDYECHV55FNXL39hwvytpLNp50WfqgLZLPXS6enMvDKVaq+r28r7KsslsxMoD0RVFay7w==
X-Received: by 2002:a17:906:eb08:b0:9fd:5708:cefd with SMTP id mb8-20020a170906eb0800b009fd5708cefdmr10544093ejb.76.1701186662648;
        Tue, 28 Nov 2023 07:51:02 -0800 (PST)
Received: from imammedo.users.ipa.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id cd19-20020a170906b35300b009ff783d892esm7045461ejb.146.2023.11.28.07.51.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Nov 2023 07:51:02 -0800 (PST)
Date: Tue, 28 Nov 2023 16:50:59 +0100
From: Igor Mammedov <imammedo@redhat.com>
To: Philippe =?UTF-8?B?TWF0aGlldS1EYXVkw6k=?= <philmd@linaro.org>
Cc: qemu-devel@nongnu.org, Laurent Vivier <laurent@vivier.eu>, Paolo Bonzini
 <pbonzini@redhat.com>, Max Filippov <jcmvbkbc@gmail.com>, David Hildenbrand
 <david@redhat.com>, Peter Xu <peterx@redhat.com>, Anton Johansson
 <anjo@rev.ng>, Peter Maydell <peter.maydell@linaro.org>,
 kvm@vger.kernel.org, Marek Vasut <marex@denx.de>, David Gibson
 <david@gibson.dropbear.id.au>, Brian Cain <bcain@quicinc.com>, Yoshinori
 Sato <ysato@users.sourceforge.jp>, "Edgar E . Iglesias"
 <edgar.iglesias@gmail.com>, Claudio Fontana <cfontana@suse.de>, Daniel
 Henrique Barboza <dbarboza@ventanamicro.com>, Artyom Tarasenko
 <atar4qemu@gmail.com>, Marcelo Tosatti <mtosatti@redhat.com>,
 qemu-ppc@nongnu.org, Liu Zhiwei <zhiwei_liu@linux.alibaba.com>, Aurelien
 Jarno <aurelien@aurel32.net>, Ilya Leoshkevich <iii@linux.ibm.com>, Daniel
 Henrique Barboza <danielhb413@gmail.com>, Bastian Koppelmann
 <kbastian@mail.uni-paderborn.de>, =?UTF-8?B?Q8OpZHJpYw==?= Le Goater
 <clg@kaod.org>, Alistair Francis <alistair.francis@wdc.com>, Alessandro Di
 Federico <ale@rev.ng>, Song Gao <gaosong@loongson.cn>, Marcel Apfelbaum
 <marcel.apfelbaum@gmail.com>, Chris Wulff <crwulff@gmail.com>, "Michael S.
 Tsirkin" <mst@redhat.com>, Alistair Francis <alistair@alistair23.me>,
 Fabiano Rosas <farosas@suse.de>, qemu-s390x@nongnu.org, Yanan Wang
 <wangyanan55@huawei.com>, Luc Michel <luc@lmichel.fr>, Weiwei Li
 <liweiwei@iscas.ac.cn>, Bin Meng <bin.meng@windriver.com>, Stafford Horne
 <shorne@gmail.com>, Xiaojuan Yang <yangxiaojuan@loongson.cn>, "Daniel P .
 Berrange" <berrange@redhat.com>, Thomas Huth <thuth@redhat.com>,
 qemu-arm@nongnu.org, Jiaxun Yang <jiaxun.yang@flygoat.com>, Richard
 Henderson <richard.henderson@linaro.org>, Aleksandar Rikalo
 <aleksandar.rikalo@syrmia.com>, Bernhard Beschow <shentey@gmail.com>, Mark
 Cave-Ayland <mark.cave-ayland@ilande.co.uk>, qemu-riscv@nongnu.org, Alex
 =?UTF-8?B?QmVubsOpZQ==?= <alex.bennee@linaro.org>, Nicholas Piggin
 <npiggin@gmail.com>, Greg Kurz <groug@kaod.org>, Michael Rolnik
 <mrolnik@gmail.com>, Eduardo Habkost <eduardo@habkost.net>, Markus
 Armbruster <armbru@redhat.com>, Palmer Dabbelt <palmer@dabbelt.com>
Subject: Re: [PATCH 03/22] target/i386/kvm: Correct comment in
 kvm_cpu_realize()
Message-ID: <20231128165059.0d991a0c@imammedo.users.ipa.redhat.com>
In-Reply-To: <20230918160257.30127-4-philmd@linaro.org>
References: <20230918160257.30127-1-philmd@linaro.org>
	<20230918160257.30127-4-philmd@linaro.org>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Mon, 18 Sep 2023 18:02:36 +0200
Philippe Mathieu-Daud=C3=A9 <philmd@linaro.org> wrote:

> Signed-off-by: Philippe Mathieu-Daud=C3=A9 <philmd@linaro.org>

Reviewed-by: Igor Mammedov <imammedo@redhat.com>

> ---
>  target/i386/kvm/kvm-cpu.c | 1 +
>  1 file changed, 1 insertion(+)
>=20
> diff --git a/target/i386/kvm/kvm-cpu.c b/target/i386/kvm/kvm-cpu.c
> index 7237378a7d..1fe62ce176 100644
> --- a/target/i386/kvm/kvm-cpu.c
> +++ b/target/i386/kvm/kvm-cpu.c
> @@ -37,6 +37,7 @@ static bool kvm_cpu_realizefn(CPUState *cs, Error **err=
p)
>       *  -> cpu_exec_realizefn():
>       *            -> accel_cpu_realizefn()
>       *               kvm_cpu_realizefn() -> host_cpu_realizefn()
> +     *  -> cpu_common_realizefn()
>       *  -> check/update ucode_rev, phys_bits, mwait
>       */
>      if (cpu->max_features) {


