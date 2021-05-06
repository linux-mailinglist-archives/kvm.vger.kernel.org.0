Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3174F3750FF
	for <lists+kvm@lfdr.de>; Thu,  6 May 2021 10:41:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233763AbhEFIme convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Thu, 6 May 2021 04:42:34 -0400
Received: from 2.mo51.mail-out.ovh.net ([178.33.255.19]:53600 "EHLO
        2.mo51.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231880AbhEFImd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 May 2021 04:42:33 -0400
Received: from mxplan5.mail.ovh.net (unknown [10.109.138.5])
        by mo51.mail-out.ovh.net (Postfix) with ESMTPS id 4E6FF288D1E;
        Thu,  6 May 2021 10:41:32 +0200 (CEST)
Received: from kaod.org (37.59.142.95) by DAG8EX1.mxp5.local (172.16.2.71)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2242.4; Thu, 6 May 2021
 10:41:31 +0200
Authentication-Results: garm.ovh; auth=pass (GARM-95G0013e49f871-4110-410e-8fd8-c83a2fe46aa9,
                    A011F864E236C67B2AFE342ECDF08F9E86568858) smtp.auth=groug@kaod.org
X-OVh-ClientIp: 78.197.208.248
Date:   Thu, 6 May 2021 10:41:30 +0200
From:   Greg Kurz <groug@kaod.org>
To:     Philippe =?UTF-8?B?TWF0aGlldS1EYXVkw6k=?= <philmd@redhat.com>
CC:     <qemu-devel@nongnu.org>,
        David Gibson <david@gibson.dropbear.id.au>,
        "Paolo Bonzini" <pbonzini@redhat.com>,
        Warner Losh <imp@bsdimp.com>, Kyle Evans <kevans@freebsd.org>,
        Alex =?UTF-8?B?QmVubsOpZQ==?= <alex.bennee@linaro.org>,
        "open list:PowerPC TCG CPUs" <qemu-ppc@nongnu.org>,
        "open list:Overall KVM CPUs" <kvm@vger.kernel.org>
Subject: Re: [PATCH 5/5] target/ppc/kvm: Replace alloca() by g_malloc()
Message-ID: <20210506104130.5f617359@bahia.lan>
In-Reply-To: <20210505170055.1415360-6-philmd@redhat.com>
References: <20210505170055.1415360-1-philmd@redhat.com>
        <20210505170055.1415360-6-philmd@redhat.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [37.59.142.95]
X-ClientProxiedBy: DAG2EX2.mxp5.local (172.16.2.12) To DAG8EX1.mxp5.local
 (172.16.2.71)
X-Ovh-Tracer-GUID: 81b71a7d-59c2-4d1c-8aa8-7f6a7006e2cf
X-Ovh-Tracer-Id: 12374484402015738159
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgeduledrvdegtddgtdeiucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuqfggjfdpvefjgfevmfevgfenuceurghilhhouhhtmecuhedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujfgurhepfffhvffukfgjfhfogggtgfhisehtqhertdertdejnecuhfhrohhmpefirhgvghcumfhurhiiuceoghhrohhugheskhgrohgurdhorhhgqeenucggtffrrghtthgvrhhnpeevlefhtddufffhieevhefhleegleelgfetffetkedugeehjeffgfehhfefueduffenucfkpheptddrtddrtddrtddpfeejrdehledrudegvddrleehnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmohguvgepshhmthhpqdhouhhtpdhhvghlohepmhigphhlrghnhedrmhgrihhlrdhovhhhrdhnvghtpdhinhgvtheptddrtddrtddrtddpmhgrihhlfhhrohhmpehgrhhouhhgsehkrghougdrohhrghdprhgtphhtthhopehkvhhmsehvghgvrhdrkhgvrhhnvghlrdhorhhg
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed,  5 May 2021 19:00:55 +0200
Philippe Mathieu-Daudé <philmd@redhat.com> wrote:

> The ALLOCA(3) man-page mentions its "use is discouraged".
> 
> Replace it by a g_malloc() call.
> 
> Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
> ---
>  target/ppc/kvm.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/target/ppc/kvm.c b/target/ppc/kvm.c
> index 104a308abb5..ae62daddf7d 100644
> --- a/target/ppc/kvm.c
> +++ b/target/ppc/kvm.c
> @@ -2698,11 +2698,11 @@ int kvmppc_save_htab(QEMUFile *f, int fd, size_t bufsize, int64_t max_ns)
>  int kvmppc_load_htab_chunk(QEMUFile *f, int fd, uint32_t index,
>                             uint16_t n_valid, uint16_t n_invalid, Error **errp)
>  {
> -    struct kvm_get_htab_header *buf;
> -    size_t chunksize = sizeof(*buf) + n_valid * HASH_PTE_SIZE_64;
> +    size_t chunksize = sizeof(struct kvm_get_htab_header)

It is a bit unfortunate to introduce a new dependency on the struct type.

What about the following ?

-    struct kvm_get_htab_header *buf;
+    g_autofree struct kvm_get_htab_header *buf = NULL;
     size_t chunksize = sizeof(*buf) + n_valid * HASH_PTE_SIZE_64;
     ssize_t rc;
 
-    buf = alloca(chunksize);
+    buf = g_malloc(chunksize);


    g_autofree struct kvm_get_htab_header *buf = NULL;
    size_t chunksize = sizeof(*buf) + n_valid * HASH_PTE_SIZE_64;

> +                       + n_valid * HASH_PTE_SIZE_64;
>      ssize_t rc;
> +    g_autofree struct kvm_get_htab_header *buf = g_malloc(chunksize);
>  
> -    buf = alloca(chunksize);
>      buf->index = index;
>      buf->n_valid = n_valid;
>      buf->n_invalid = n_invalid;
> @@ -2741,10 +2741,10 @@ void kvmppc_read_hptes(ppc_hash_pte64_t *hptes, hwaddr ptex, int n)
>      i = 0;
>      while (i < n) {
>          struct kvm_get_htab_header *hdr;
> +        char buf[sizeof(*hdr) + HPTES_PER_GROUP * HASH_PTE_SIZE_64];
>          int m = n < HPTES_PER_GROUP ? n : HPTES_PER_GROUP;
> -        char buf[sizeof(*hdr) + m * HASH_PTE_SIZE_64];
>  
> -        rc = read(fd, buf, sizeof(buf));
> +        rc = read(fd, buf, sizeof(*hdr) + m * HASH_PTE_SIZE_64);
>          if (rc < 0) {
>              hw_error("kvmppc_read_hptes: Unable to read HPTEs");
>          }

