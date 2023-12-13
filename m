Return-Path: <kvm+bounces-4012-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1906D80BF75
	for <lists+kvm@lfdr.de>; Mon, 11 Dec 2023 03:51:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C3127280C56
	for <lists+kvm@lfdr.de>; Mon, 11 Dec 2023 02:51:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C4ADE15AF6;
	Mon, 11 Dec 2023 02:51:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=canb.auug.org.au header.i=@canb.auug.org.au header.b="FlJaLcfv"
X-Original-To: kvm@vger.kernel.org
Received: from gandalf.ozlabs.org (mail.ozlabs.org [IPv6:2404:9400:2221:ea00::3])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 937A21FD2;
	Sun, 10 Dec 2023 18:51:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
	s=201702; t=1702263056;
	bh=Sq8nbVEcRVues8cBbXzwXlj2IWgRQ6rEbTmY8CyoHEQ=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=FlJaLcfvWS0edDd1sYTx/8DzmUXQDkHkg7aaaVy2DXBd/DYjO4uRS7amjU047M51z
	 0leWYyiuNja1b+mhQqTLXKFmZeAExiFUs4Yahv5l6+i/QqscvmIrvMNyTOay2c5qBH
	 ViUrDHolpRMPXcQRpUmsTwkjiuQev7Rcyx1SdwDlbPwnh/mO3381+uTrqfsdEOTguO
	 4Gsvr1lOrZBGId28c59lxYnjBFFZpHbAngOG6PRuQBGu2Q7ClTVeBrLzcdg69A+85q
	 BBOaMws56i3778t58GsA6YA68vMMA/KRAGmHRR5UEuW+hy8uYJxpN3SZlYbFvwFdOK
	 sJW1eehFHeiiA==
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.ozlabs.org (Postfix) with ESMTPSA id 4SpR7y06KGz4xNH;
	Mon, 11 Dec 2023 13:50:53 +1100 (AEDT)
Date: Mon, 11 Dec 2023 13:50:52 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Paolo Bonzini <pbonzini@redhat.com>, Andrew Morton
 <akpm@linux-foundation.org>
Cc: KVM <kvm@vger.kernel.org>, Ackerley Tng <ackerleytng@google.com>, Chao
 Peng <chao.p.peng@linux.intel.com>, Isaku Yamahata
 <isaku.yamahata@intel.com>, "Kirill A. Shutemov"
 <kirill.shutemov@linux.intel.com>, Michael Roth <michael.roth@amd.com>,
 Sean Christopherson <seanjc@google.com>, Yu Zhang
 <yu.c.zhang@linux.intel.com>, "Matthew Wilcox (Oracle)"
 <willy@infradead.org>, Linux Kernel Mailing List
 <linux-kernel@vger.kernel.org>, Linux Next Mailing List
 <linux-next@vger.kernel.org>
Subject: Re: linux-next: build failure after merge of the kvm tree
Message-ID: <20231211135052.4fb016a6@canb.auug.org.au>
In-Reply-To: <20231120152227.3bfe2450@canb.auug.org.au>
References: <20231120152227.3bfe2450@canb.auug.org.au>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/k6L+z4ZF5AITNIBFCyYc60_";
 protocol="application/pgp-signature"; micalg=pgp-sha256

--Sig_/k6L+z4ZF5AITNIBFCyYc60_
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

On Mon, 20 Nov 2023 15:22:27 +1100 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> After merging the kvm tree, today's linux-next build (x86_64 allmodconfig)
> failed like this:
>=20
> arch/x86/kvm/../../../virt/kvm/guest_memfd.c:306:10: error: 'const struct=
 address_space_operations' has no member named 'error_remove_page'; did you=
 mean 'error_remove_folio'?
>   306 |         .error_remove_page =3D kvm_gmem_error_page,
>       |          ^~~~~~~~~~~~~~~~~
>       |          error_remove_folio
> arch/x86/kvm/../../../virt/kvm/guest_memfd.c:306:30: error: initializatio=
n of 'int (*)(struct folio *)' from incompatible pointer type 'int (*)(stru=
ct address_space *, struct page *)' [-Werror=3Dincompatible-pointer-types]
>   306 |         .error_remove_page =3D kvm_gmem_error_page,
>       |                              ^~~~~~~~~~~~~~~~~~~
> arch/x86/kvm/../../../virt/kvm/guest_memfd.c:306:30: note: (near initiali=
zation for 'kvm_gmem_aops.launder_folio')
>=20
> Caused by commit
>=20
>   640be5bc564f ("fs: convert error_remove_page to error_remove_folio")
>=20
> from the mm tree intercting with commit
>=20
>   a7800aa80ea4 ("KVM: Add KVM_CREATE_GUEST_MEMFD ioctl() for guest-specif=
ic backing memory")
>=20
> I have applied the following supplied merge fix patch (thanks Andrew).
>=20
> From: Andrew Morton <akpm@linux-foundation.org>
> Date: Fri, 17 Nov 2023 09:28:33 -0800
> Subject: [PATCH] fs: Convert error_remove_page to error_remove_folio
>=20
> On Fri, 17 Nov 2023 16:14:47 +0000 "Matthew Wilcox (Oracle)" <willy@infra=
dead.org> wrote:
>=20
> > There were already assertions that we were not passing a tail page
> > to error_remove_page(), so make the compiler enforce that by converting
> > everything to pass and use a folio.
> >
> > Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> > ---
> >  Documentation/filesystems/locking.rst |  4 ++--
> >  Documentation/filesystems/vfs.rst     |  6 +++---
> >  block/fops.c                          |  2 +-
> >  fs/afs/write.c                        |  2 +-
> >  fs/bcachefs/fs.c                      |  2 +-
> >  fs/btrfs/inode.c                      |  2 +-
> >  fs/ceph/addr.c                        |  4 ++--
> >  fs/ext2/inode.c                       |  2 +-
> >  fs/ext4/inode.c                       |  6 +++---
> >  fs/f2fs/compress.c                    |  2 +-
> >  fs/f2fs/inode.c                       |  2 +-
> >  fs/gfs2/aops.c                        |  4 ++--
> >  fs/hugetlbfs/inode.c                  |  6 +++---
> >  fs/nfs/file.c                         |  2 +-
> >  fs/ntfs/aops.c                        |  6 +++---
> >  fs/ocfs2/aops.c                       |  2 +-
> >  fs/xfs/xfs_aops.c                     |  2 +-
> >  fs/zonefs/file.c                      |  2 +-
> >  include/linux/fs.h                    |  2 +-
> >  include/linux/mm.h                    |  3 ++-
> >  mm/memory-failure.c                   | 10 +++++-----
> >  mm/shmem.c                            |  6 +++---
> >  mm/truncate.c                         |  9 ++++-----
> >  virt/kvm/guest_memfd.c                |  9 +++++---- =20
>=20
> virt/kvm/guest_memfd.c exists only in the KVM tree (and hence
> linux-next).  So I assume Stephen will use the change from this patch
> when doing his resolution.
>=20
> This:
> ---
Now this:

 virt/kvm/guest_memfd.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index c2e2371720a9..c23ce219e21c 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -267,7 +267,8 @@ static int kvm_gmem_migrate_folio(struct address_space =
*mapping,
 	return -EINVAL;
 }
=20
-static int kvm_gmem_error_page(struct address_space *mapping, struct page =
*page)
+static int kvm_gmem_error_folio(struct address_space *mapping,
+		struct folio *folio)
 {
 	struct list_head *gmem_list =3D &mapping->private_list;
 	struct kvm_gmem *gmem;
@@ -275,8 +276,8 @@ static int kvm_gmem_error_page(struct address_space *ma=
pping, struct page *page)
=20
 	filemap_invalidate_lock_shared(mapping);
=20
-	start =3D page->index;
-	end =3D start + thp_nr_pages(page);
+	start =3D folio->index;
+	end =3D start + folio_nr_pages(folio);
=20
 	list_for_each_entry(gmem, gmem_list, entry)
 		kvm_gmem_invalidate_begin(gmem, start, end);
@@ -301,7 +302,7 @@ static int kvm_gmem_error_page(struct address_space *ma=
pping, struct page *page)
 static const struct address_space_operations kvm_gmem_aops =3D {
 	.dirty_folio =3D noop_dirty_folio,
 	.migrate_folio	=3D kvm_gmem_migrate_folio,
-	.error_remove_page =3D kvm_gmem_error_page,
+	.error_remove_folio =3D kvm_gmem_error_folio,
 };
=20
 static int kvm_gmem_getattr(struct mnt_idmap *idmap, const struct path *pa=
th,

--=20
Cheers,
Stephen Rothwell

--Sig_/k6L+z4ZF5AITNIBFCyYc60_
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmV2eQwACgkQAVBC80lX
0GxNSAf/dDZBSEWcxmOyeozZ/ArXSlpS/X2SmABjDh02ed8wURGrwmrayYtj4HF2
YnxLKEulMDxUjOT3upvFvamu/xaZhDFwEfBboxjvJ4rqbYKUeBOoB0S8UKAEee7P
yW0lW0+nvqDqc7nfHCGtBPIq9VsIUdi6P9YD9XHcYuuA73pEL8ZVGi8aWZEOlU8d
UZ3q9qsMlWZS5Na1RDgIjFR+hY89xCCI3hWwGx5Cw1Dj/MYDqSgsOVENnBrSvBgx
gWbemvzi5rAdiAZTcFrTlHKTlU6+eJAsmyZzofR3ddwbVs1DX1rIqIZKUZDyhLiG
ydPrmhDb0eopw1fDRwxu1M0yTAnVIA==
=EZzi
-----END PGP SIGNATURE-----

--Sig_/k6L+z4ZF5AITNIBFCyYc60_--

