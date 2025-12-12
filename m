Return-Path: <kvm+bounces-65819-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 35CFECB88A8
	for <lists+kvm@lfdr.de>; Fri, 12 Dec 2025 10:56:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id A40EA3010041
	for <lists+kvm@lfdr.de>; Fri, 12 Dec 2025 09:56:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 784F131618B;
	Fri, 12 Dec 2025 09:56:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WYyYMDG8"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B63CE314A67
	for <kvm@vger.kernel.org>; Fri, 12 Dec 2025 09:56:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765533402; cv=none; b=Sw8gpxrpHrUV58PWR7Vvb+VsZjtAPcBKOs7JHve7Nkm9fmzIChlET3FBWVr3LXwBWgttopFHgEhQJKBT0pTkHdUbRcFEze57v04Bwh/WYkm+inwsNefTOhUItQ3UPhDRK6Sj08aO4NhQTxU/G+sDDy8OtOvjEpdq7heOEvVPGUc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765533402; c=relaxed/simple;
	bh=vzrPTe6tWbjo3TZD0kuIMnGXW0nGVoxveA/z5Qe2BW8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=rKN3TNQ2/AEX8Z8zMqYQL18EWZCjtvwC0NCMRazaVo7Z2jiHI+mTsonI7TJ7Tuh/kVl4jWlggdoqwnIqkRtVJTVU2ykR9SSfzrca7iZ9+WEuFWnUpe611HDSZla9fgvW3zK2SSxaWtvXfiZDPdVpkdUPyWtVKjp2MDdBO60rL9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WYyYMDG8; arc=none smtp.client-ip=209.85.210.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-7acd9a03ba9so1113834b3a.1
        for <kvm@vger.kernel.org>; Fri, 12 Dec 2025 01:56:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765533400; x=1766138200; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KLMqFAAdIauxmlnkadIw2CSPl4PtuGOhN0UCxB5GAo0=;
        b=WYyYMDG85ZTyzrSmlUYmNMLskipUtgzfJHppcw7/lS231OBPrNwFqkML/UKT6fQtsJ
         D7ua6Wo7LrZEzdGXg/DzDiG/MI8LExZNidQM0b6C7BQNImZHyIvG4qZv9/wns6DUYmy/
         6CNLuC628mlFKEG4v3NDxjEMElrvC8jmYyp/AopyFpnbxfxNCO6asPwKs/GNvyCCGNWB
         5v3I9aL2dlQaNVfC6upjmEhEHXxbayJcA4uBXCtZWaWETMzEcgBwfbwOuIZRJn7p4qVu
         n0pvRNGBvlHgf5xZ82zKhPJSNkZE8Q1eeQv0jDElQlU1QqE12CYA6Hn9wNTmMVm3bQq/
         qMmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765533400; x=1766138200;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=KLMqFAAdIauxmlnkadIw2CSPl4PtuGOhN0UCxB5GAo0=;
        b=tY4tCDAjbSXAvmtmrRoXJHJUYygyYKL6XmzOvUUfiffjupzB/NE7Qn1npupcbJV9ix
         PLYcDgSOX9ABFZrs8co3v7BGToAlc+HL6uQVxJon5GZ/ThCpVSFk1sFlLCSeu6an92kn
         baHV6x33tbcrhNY9k9KQxixPvX+eB+V0s+Ky0KWwd7EJIVz7prk4/eQCpVlGUh1rhzH7
         XTYEQmJyKIKrkgG5GDX82g72w7sEVu8CvQDRICjOakt5JFDZ69R1nqo4S61An2i5Nr15
         LIwuQo74ld0Idn2yHicj1bfNmVr9K55fOl89kNoYoxg0xq+bKU+PW+skkSJ2+jx8ruww
         Gnyw==
X-Forwarded-Encrypted: i=1; AJvYcCVBl7Mw5Lr2cGp5xtHerHP1894kPRIyIX834iWFDNxehxSeppofALbkXKnk4+K8TZke4Tg=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzwhe4VmE+wMOAFsWvCdb4AFDiZ3KIZvTCnr9QGC15cz65c6SD+
	Vk2oYsjlPCjXlIKfq5/ZusOnITGvMy47mUBCP1b4YFA3xsnRqfK25qoGNzVgW/LYYLWcWrjzHku
	6yWurQoJx2ygzqjL8P7p7iup1HvAUCEo=
X-Gm-Gg: AY/fxX473y2G30j9IWqrC0hGwUFAoEBVB77LnOb088RSgZjZ1QRAGMmEMMYrEfO0CpF
	WpKMA3zbijwSCKS8k6hjDcLzSCqCanW2XLyNwmaRmS8W65iaqMDgZLWoyOaaVElGJu5fdOGZoBT
	rYj8XYBJe75W3GsuSHHci9n8/A3Ge1SXiV9yOsJENB60q238LdYODYoYRRg3pVV4FL9/Ryf2ipK
	LefRF7Tg/Pq9UsxoqPjddE8uYAnDnUTc5tzoQGWxoDEt2nclVw6vWu8oFaPO1O1xs9uBtHSkBHa
	+LkOJw==
X-Google-Smtp-Source: AGHT+IF+MW5K/8f2ZlLti/MqPEr89rcyIW6G8tr+DjlxGFmd8Bi1g29ZZOBPNDRALG/ZTgiZZFA0I+6bSTr9ba+NtlM=
X-Received: by 2002:a05:6a20:7490:b0:342:fa4f:5843 with SMTP id
 adf61e73a8af0-369afdf6ba8mr1581346637.43.1765533399890; Fri, 12 Dec 2025
 01:56:39 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251211125104.375020-1-mlbnkm1@gmail.com> <20251211080251-mutt-send-email-mst@kernel.org>
 <zlhixzduyindq24osaedkt2xnukmatwhugfkqmaugvor6wlcol@56jsodxn4rhi>
 <CAMKc4jDpMsk1TtSN-GPLM1M_qp_jpoE1XL1g5qXRUiB-M0BPgQ@mail.gmail.com> <CAGxU2F7WOLs7bDJao-7Qd=GOqj_tOmS+EptviMphGqSrgsadqg@mail.gmail.com>
In-Reply-To: <CAGxU2F7WOLs7bDJao-7Qd=GOqj_tOmS+EptviMphGqSrgsadqg@mail.gmail.com>
From: Melbin Mathew Antony <mlbnkm1@gmail.com>
Date: Fri, 12 Dec 2025 09:56:28 +0000
X-Gm-Features: AQt7F2rG1UB-jri8C-jmTNn7YB4raUtC9tILlV9CoPgmqbVR0wSWJFVmVu43Amk
Message-ID: <CAMKc4jDLdcGsL5_d+4CP6n-57s-R0vzrX2M7Ni=1GeCB1cxVYA@mail.gmail.com>
Subject: Re: [PATCH net v3] vsock/virtio: cap TX credit to local buffer size
To: Stefano Garzarella <sgarzare@redhat.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, stefanha@redhat.com, kvm@vger.kernel.org, 
	netdev@vger.kernel.org, virtualization@lists.linux.dev, 
	linux-kernel@vger.kernel.org, jasowang@redhat.com, xuanzhuo@linux.alibaba.com, 
	eperezma@redhat.com, davem@davemloft.net, edumazet@google.com, 
	kuba@kernel.org, pabeni@redhat.com, horms@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Stefano, Michael,

Thanks for the suggestions and guidance.

I=E2=80=99ve drafted a 4-part series based on the recap. I=E2=80=99ve inclu=
ded the
four diffs below for discussion. Can wait for comments, iterate, and
then send the patch series in a few days.

---

Patch 1/4 =E2=80=94 vsock/virtio: make get_credit() s64-safe and clamp nega=
tives

virtio_transport_get_credit() was doing unsigned arithmetic; if the
peer shrinks its window, the subtraction can underflow and look like
=E2=80=9Clots of credit=E2=80=9D. This makes it compute =E2=80=9Cspace=E2=
=80=9D in s64 and clamp < 0
to 0.

diff --git a/net/vmw_vsock/virtio_transport_common.c
b/net/vmw_vsock/virtio_transport_common.c
--- a/net/vmw_vsock/virtio_transport_common.c
+++ b/net/vmw_vsock/virtio_transport_common.c
@@ -494,16 +494,23 @@ EXPORT_SYMBOL_GPL(virtio_transport_consume_skb_sent);
 u32 virtio_transport_get_credit(struct virtio_vsock_sock *vvs, u32 credit)
 {
+ s64 bytes;
  u32 ret;

  if (!credit)
  return 0;

  spin_lock_bh(&vvs->tx_lock);
- ret =3D vvs->peer_buf_alloc - (vvs->tx_cnt - vvs->peer_fwd_cnt);
- if (ret > credit)
- ret =3D credit;
+ bytes =3D (s64)vvs->peer_buf_alloc -
+ ((s64)vvs->tx_cnt - (s64)vvs->peer_fwd_cnt);
+ if (bytes < 0)
+ bytes =3D 0;
+
+ ret =3D min_t(u32, credit, (u32)bytes);
  vvs->tx_cnt +=3D ret;
  vvs->bytes_unsent +=3D ret;
  spin_unlock_bh(&vvs->tx_lock);

  return ret;
 }


---

Patch 2/4 =E2=80=94 vsock/virtio: cap TX window by local buffer (helper + u=
se
everywhere in TX path)

Cap the effective advertised window to min(peer_buf_alloc, buf_alloc)
and use it consistently in TX paths (get_credit, has_space,
seqpacket_enqueue).

diff --git a/net/vmw_vsock/virtio_transport_common.c
b/net/vmw_vsock/virtio_transport_common.c
--- a/net/vmw_vsock/virtio_transport_common.c
+++ b/net/vmw_vsock/virtio_transport_common.c
@@ -491,6 +491,16 @@ void virtio_transport_consume_skb_sent(struct
sk_buff *skb, bool consume)
 }
 EXPORT_SYMBOL_GPL(virtio_transport_consume_skb_sent);
+/* Return the effective peer buffer size for TX credit computation.
+ *
+ * The peer advertises its receive buffer via peer_buf_alloc, but we cap i=
t
+ * to our local buf_alloc (derived from SO_VM_SOCKETS_BUFFER_SIZE and
+ * already clamped to buffer_max_size).
+ */
+static u32 virtio_transport_tx_buf_alloc(struct virtio_vsock_sock *vvs)
+{
+ return min(vvs->peer_buf_alloc, vvs->buf_alloc);
+}

 u32 virtio_transport_get_credit(struct virtio_vsock_sock *vvs, u32 credit)
 {
  s64 bytes;
@@ -502,7 +512,8 @@ u32 virtio_transport_get_credit(struct
virtio_vsock_sock *vvs, u32 credit)
  return 0;

  spin_lock_bh(&vvs->tx_lock);
- bytes =3D (s64)vvs->peer_buf_alloc -
+ bytes =3D (s64)virtio_transport_tx_buf_alloc(vvs) -
  ((s64)vvs->tx_cnt - (s64)vvs->peer_fwd_cnt);
  if (bytes < 0)
  bytes =3D 0;
@@ -834,7 +845,7 @@ virtio_transport_seqpacket_enqueue(struct vsock_sock *v=
sk,
  spin_lock_bh(&vvs->tx_lock);

- if (len > vvs->peer_buf_alloc) {
+ if (len > virtio_transport_tx_buf_alloc(vvs)) {
  spin_unlock_bh(&vvs->tx_lock);
  return -EMSGSIZE;
  }
@@ -884,7 +895,8 @@ static s64 virtio_transport_has_space(struct
vsock_sock *vsk)
  struct virtio_vsock_sock *vvs =3D vsk->trans;
  s64 bytes;

- bytes =3D (s64)vvs->peer_buf_alloc - (vvs->tx_cnt - vvs->peer_fwd_cnt);
+ bytes =3D (s64)virtio_transport_tx_buf_alloc(vvs) -
+ ((s64)vvs->tx_cnt - (s64)vvs->peer_fwd_cnt);
  if (bytes < 0)
  bytes =3D 0;

  return bytes;
 }


---

Patch 3/4 =E2=80=94 vsock/test: fix seqpacket msg bounds test (set client b=
uf too)

After fixing TX credit bounds, the client can fill its TX window and
block before it wakes the server. Setting the buffer on the client
makes the test deterministic again.

diff --git a/tools/testing/vsock/vsock_test.c b/tools/testing/vsock/vsock_t=
est.c
--- a/tools/testing/vsock/vsock_test.c
+++ b/tools/testing/vsock/vsock_test.c
@@ -353,6 +353,7 @@ static void test_stream_msg_peek_server(const
struct test_opts *opts)

 static void test_seqpacket_msg_bounds_client(const struct test_opts *opts)
 {
+ unsigned long long sock_buf_size;
  unsigned long curr_hash;
  size_t max_msg_size;
  int page_size;
@@ -366,6 +367,18 @@ static void
test_seqpacket_msg_bounds_client(const struct test_opts *opts)
  exit(EXIT_FAILURE);
  }

+ sock_buf_size =3D SOCK_BUF_SIZE;
+
+ setsockopt_ull_check(fd, AF_VSOCK, SO_VM_SOCKETS_BUFFER_MAX_SIZE,
+    sock_buf_size,
+    "setsockopt(SO_VM_SOCKETS_BUFFER_MAX_SIZE)");
+
+ setsockopt_ull_check(fd, AF_VSOCK, SO_VM_SOCKETS_BUFFER_SIZE,
+    sock_buf_size,
+    "setsockopt(SO_VM_SOCKETS_BUFFER_SIZE)");
+
  /* Wait, until receiver sets buffer size. */
  control_expectln("SRVREADY");


---

Patch 4/4 =E2=80=94 vsock/test: add stream TX credit bounds regression test

This directly guards the original failure mode for stream sockets: if
the peer advertises a large window but the sender=E2=80=99s local policy is
small, the sender must stall quickly (hit EAGAIN in nonblocking mode)
rather than queueing megabytes.

diff --git a/tools/testing/vsock/vsock_test.c b/tools/testing/vsock/vsock_t=
est.c
--- a/tools/testing/vsock/vsock_test.c
+++ b/tools/testing/vsock/vsock_test.c
@@ -349,6 +349,7 @@
 #define SOCK_BUF_SIZE (2 * 1024 * 1024)
+#define SMALL_SOCK_BUF_SIZE (64 * 1024ULL)
 #define MAX_MSG_PAGES 4

 /* Insert new test functions after test_stream_msg_peek_server, before
  * test_seqpacket_msg_bounds_client (around line 352) */

+static void test_stream_tx_credit_bounds_client(const struct test_opts *op=
ts)
+{
+ ... /* full function as provided */
+}
+
+static void test_stream_tx_credit_bounds_server(const struct test_opts *op=
ts)
+{
+ ... /* full function as provided */
+}

@@ -2224,6 +2305,10 @@
  .run_client =3D test_stream_msg_peek_client,
  .run_server =3D test_stream_msg_peek_server,
  },
+ {
+ .name =3D "SOCK_STREAM TX credit bounds",
+ .run_client =3D test_stream_tx_credit_bounds_client,
+ .run_server =3D test_stream_tx_credit_bounds_server,
+ },
  {
  .name =3D "SOCK_SEQPACKET msg bounds",

On Thu, Dec 11, 2025 at 2:52=E2=80=AFPM Stefano Garzarella <sgarzare@redhat=
.com> wrote:
>
> On Thu, 11 Dec 2025 at 15:44, Melbin Mathew Antony <mlbnkm1@gmail.com> wr=
ote:
> >
> > Hi Stefano, Michael,
> >
> > Thanks for the feedback and for pointing out the s64 issue in
> > virtio_transport_get_credit() and the vsock_test regression.
> >
> > I can take this up and send a small series:
> >
> >   1/2 =E2=80=93 vsock/virtio: cap TX credit to local buffer size
> >         - use a helper to bound peer_buf_alloc by buf_alloc
> >         - compute available credit in s64 like has_space(), and clamp
> >           negative values to zero before applying the caller=E2=80=99s =
credit
>
> IMO they should be fixed in 2 different patches.
>
> I think we can easily reuse virtio_transport_has_space() in
> virtio_transport_get_credit().
>
> >
> >   2/2 =E2=80=93 vsock/test: fix seqpacket message bounds test
> >         - include your vsock_test.c change so the seqpacket bounds test
> >           keeps working with the corrected TX credit handling
> >
> > I=E2=80=99ll roll these into a [PATCH net v4 0/2] series and send it ou=
t shortly.
>
> Please, wait a bit also for other maintainers comments.
> See https://www.kernel.org/doc/html/latest/process/submitting-patches.htm=
l#don-t-get-discouraged-or-impatient
>
> So, to recap I'd do the following:
> Patch 1: fix virtio_transport_get_credit() maybe using
> virtio_transport_has_space() to calculate the space
> Patch 2: (this one) cap TX credit to local buffer size
> Patch 3: vsock/test: fix seqpacket message bounds test
> Patch 4 (if you have time): add a new test for TX credit on stream socket
>
> Stefano
>
> >
> > Thanks again for all the guidance,
> > Melbin
> >
> >
> > On Thu, Dec 11, 2025 at 1:57=E2=80=AFPM Stefano Garzarella <sgarzare@re=
dhat.com> wrote:
> > >
> > > On Thu, Dec 11, 2025 at 08:05:11AM -0500, Michael S. Tsirkin wrote:
> > > >On Thu, Dec 11, 2025 at 01:51:04PM +0100, Melbin K Mathew wrote:
> > > >> The virtio vsock transport currently derives its TX credit directl=
y from
> > > >> peer_buf_alloc, which is populated from the remote endpoint's
> > > >> SO_VM_SOCKETS_BUFFER_SIZE value.
> > > >>
> > > >> On the host side, this means the amount of data we are willing to =
queue
> > > >> for a given connection is scaled purely by a peer-chosen value, ra=
ther
> > > >> than by the host's own vsock buffer configuration. A guest that
> > > >> advertises a very large buffer and reads slowly can cause the host=
 to
> > > >> allocate a correspondingly large amount of sk_buff memory for that
> > > >> connection.
> > > >>
> > > >> In practice, a malicious guest can:
> > > >>
> > > >>   - set a large AF_VSOCK buffer size (e.g. 2 GiB) with
> > > >>     SO_VM_SOCKETS_BUFFER_MAX_SIZE / SO_VM_SOCKETS_BUFFER_SIZE, and
> > > >>
> > > >>   - open multiple connections to a host vsock service that sends d=
ata
> > > >>     while the guest drains slowly.
> > > >>
> > > >> On an unconstrained host this can drive Slab/SUnreclaim into the t=
ens of
> > > >> GiB range, causing allocation failures and OOM kills in unrelated =
host
> > > >> processes while the offending VM remains running.
> > > >>
> > > >> On non-virtio transports and compatibility:
> > > >>
> > > >>   - VMCI uses the AF_VSOCK buffer knobs to size its queue pairs pe=
r
> > > >>     socket based on the local vsk->buffer_* values; the remote sid=
e
> > > >>     can=E2=80=99t enlarge those queues beyond what the local endpo=
int
> > > >>     configured.
> > > >>
> > > >>   - Hyper-V=E2=80=99s vsock transport uses fixed-size VMBus ring b=
uffers and
> > > >>     an MTU bound; there is no peer-controlled credit field compara=
ble
> > > >>     to peer_buf_alloc, and the remote endpoint can=E2=80=99t drive=
 in-flight
> > > >>     kernel memory above those ring sizes.
> > > >>
> > > >>   - The loopback path reuses virtio_transport_common.c, so it
> > > >>     naturally follows the same semantics as the virtio transport.
> > > >>
> > > >> Make virtio-vsock consistent with that model by intersecting the p=
eer=E2=80=99s
> > > >> advertised receive window with the local vsock buffer size when
> > > >> computing TX credit. We introduce a small helper and use it in
> > > >> virtio_transport_get_credit(), virtio_transport_has_space() and
> > > >> virtio_transport_seqpacket_enqueue(), so that:
> > > >>
> > > >>     effective_tx_window =3D min(peer_buf_alloc, buf_alloc)
> > > >>
> > > >> This prevents a remote endpoint from forcing us to queue more data=
 than
> > > >> our own configuration allows, while preserving the existing credit
> > > >> semantics and keeping virtio-vsock compatible with the other trans=
ports.
> > > >>
> > > >> On an unpatched Ubuntu 22.04 host (~64 GiB RAM), running a PoC wit=
h
> > > >> 32 guest vsock connections advertising 2 GiB each and reading slow=
ly
> > > >> drove Slab/SUnreclaim from ~0.5 GiB to ~57 GiB and the system only
> > > >> recovered after killing the QEMU process.
> > > >>
> > > >> With this patch applied, rerunning the same PoC yields:
> > > >>
> > > >>   Before:
> > > >>     MemFree:        ~61.6 GiB
> > > >>     MemAvailable:   ~62.3 GiB
> > > >>     Slab:           ~142 MiB
> > > >>     SUnreclaim:     ~117 MiB
> > > >>
> > > >>   After 32 high-credit connections:
> > > >>     MemFree:        ~61.5 GiB
> > > >>     MemAvailable:   ~62.3 GiB
> > > >>     Slab:           ~178 MiB
> > > >>     SUnreclaim:     ~152 MiB
> > > >>
> > > >> i.e. only ~35 MiB increase in Slab/SUnreclaim, no host OOM, and th=
e
> > > >> guest remains responsive.
> > > >>
> > > >> Fixes: 06a8fc78367d ("VSOCK: Introduce virtio_vsock_common.ko")
> > > >> Suggested-by: Stefano Garzarella <sgarzare@redhat.com>
> > > >> Signed-off-by: Melbin K Mathew <mlbnkm1@gmail.com>
> > > >> ---
> > > >>  net/vmw_vsock/virtio_transport_common.c | 27 ++++++++++++++++++++=
++---
> > > >>  1 file changed, 24 insertions(+), 3 deletions(-)
> > > >>
> > > >> diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vso=
ck/virtio_transport_common.c
> > > >> index dcc8a1d58..02eeb96dd 100644
> > > >> --- a/net/vmw_vsock/virtio_transport_common.c
> > > >> +++ b/net/vmw_vsock/virtio_transport_common.c
> > > >> @@ -491,6 +491,25 @@ void virtio_transport_consume_skb_sent(struct=
 sk_buff *skb, bool consume)
> > > >>  }
> > > >>  EXPORT_SYMBOL_GPL(virtio_transport_consume_skb_sent);
> > > >>
> > > >> +/* Return the effective peer buffer size for TX credit computatio=
n.
> > > >> + *
> > > >> + * The peer advertises its receive buffer via peer_buf_alloc, but=
 we
> > > >> + * cap that to our local buf_alloc (derived from
> > > >> + * SO_VM_SOCKETS_BUFFER_SIZE and already clamped to buffer_max_si=
ze)
> > > >> + * so that a remote endpoint cannot force us to queue more data t=
han
> > > >> + * our own configuration allows.
> > > >> + */
> > > >> +static u32 virtio_transport_tx_buf_alloc(struct virtio_vsock_sock=
 *vvs)
> > > >> +{
> > > >> +    return min(vvs->peer_buf_alloc, vvs->buf_alloc);
> > > >> +}
> > > >> +
> > > >>  u32 virtio_transport_get_credit(struct virtio_vsock_sock *vvs, u3=
2 credit)
> > > >>  {
> > > >>      u32 ret;
> > > >> @@ -499,7 +518,8 @@ u32 virtio_transport_get_credit(struct virtio_=
vsock_sock *vvs, u32 credit)
> > > >>              return 0;
> > > >>
> > > >>      spin_lock_bh(&vvs->tx_lock);
> > > >> -    ret =3D vvs->peer_buf_alloc - (vvs->tx_cnt - vvs->peer_fwd_cn=
t);
> > > >> +    ret =3D virtio_transport_tx_buf_alloc(vvs) -
> > > >> +            (vvs->tx_cnt - vvs->peer_fwd_cnt);
> > > >>      if (ret > credit)
> > > >>              ret =3D credit;
> > > >>      vvs->tx_cnt +=3D ret;
> > > >> @@ -831,7 +851,7 @@ virtio_transport_seqpacket_enqueue(struct vsoc=
k_sock *vsk,
> > > >>
> > > >>      spin_lock_bh(&vvs->tx_lock);
> > > >>
> > > >> -    if (len > vvs->peer_buf_alloc) {
> > > >> +    if (len > virtio_transport_tx_buf_alloc(vvs)) {
> > > >>              spin_unlock_bh(&vvs->tx_lock);
> > > >>              return -EMSGSIZE;
> > > >>      }
> > > >> @@ -882,7 +902,8 @@ static s64 virtio_transport_has_space(struct v=
sock_sock *vsk)
> > > >>      struct virtio_vsock_sock *vvs =3D vsk->trans;
> > > >>      s64 bytes;
> > > >>
> > > >> -    bytes =3D (s64)vvs->peer_buf_alloc - (vvs->tx_cnt - vvs->peer=
_fwd_cnt);
> > > >> +    bytes =3D (s64)virtio_transport_tx_buf_alloc(vvs) -
> > > >> +            (vvs->tx_cnt - vvs->peer_fwd_cnt);
> > > >>      if (bytes < 0)
> > > >>              bytes =3D 0;
> > > >>
> > > >
> > > >Acked-by: Michael S. Tsirkin <mst@redhat.com>
> > > >
> > > >
> > > >Looking at this, why is one place casting to s64 the other is not?
> > >
> > > Yeah, I pointed out that too in previous interactions. IMO we should =
fix
> > > virtio_transport_get_credit() since the peer can reduce `peer_buf_all=
oc`
> > > so it will overflow. Fortunately, we are limited by the credit reques=
ted
> > > by the caller, but we are still sending stuff when we shouldn't be.
> > >
> > > @Melbin let me know if you will fix it, otherwise I can do that, but =
I'd
> > > like to do in a single series (multiple patches), since they depends =
on
> > > each other.
> > >
> > > So if you prefer, I can pickup this patch and post a series with this=
 +
> > > the other fix + the fix on the test I posted on the v2.
> > >
> > > Stefano
> > >
> >
>

