Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C88C2A13DF
	for <lists+kvm@lfdr.de>; Sat, 31 Oct 2020 07:36:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726407AbgJaGgn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 31 Oct 2020 02:36:43 -0400
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:15757 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726395AbgJaGgm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 31 Oct 2020 02:36:42 -0400
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5f9d05fe0000>; Fri, 30 Oct 2020 23:36:46 -0700
Received: from [10.2.58.85] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Sat, 31 Oct
 2020 06:36:35 +0000
Subject: Re: [PATCH v5 13/15] resource: Move devmem revoke code to resource
 framework
To:     Daniel Vetter <daniel.vetter@ffwll.ch>,
        DRI Development <dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>
CC:     <kvm@vger.kernel.org>, <linux-mm@kvack.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-samsung-soc@vger.kernel.org>, <linux-media@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Daniel Vetter <daniel.vetter@intel.com>,
        "Jason Gunthorpe" <jgg@ziepe.ca>,
        Kees Cook <keescook@chromium.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>,
        Jan Kara <jack@suse.cz>, Arnd Bergmann <arnd@arndb.de>,
        David Hildenbrand <david@redhat.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
References: <20201030100815.2269-1-daniel.vetter@ffwll.ch>
 <20201030100815.2269-14-daniel.vetter@ffwll.ch>
From:   John Hubbard <jhubbard@nvidia.com>
Message-ID: <787f2914-5777-4703-4bee-68c4c3742817@nvidia.com>
Date:   Fri, 30 Oct 2020 23:36:35 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20201030100815.2269-14-daniel.vetter@ffwll.ch>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1604126206; bh=L4oBpwCPTK9i7x4n5WL1+chs0FMLfmAUGEi3yv+lcuI=;
        h=Subject:To:CC:References:From:Message-ID:Date:User-Agent:
         MIME-Version:In-Reply-To:Content-Type:Content-Language:
         Content-Transfer-Encoding:X-Originating-IP:X-ClientProxiedBy;
        b=WZ7JBVVRAPxiUhUbHLrJz0ng6xWLVDFeI5F6t0NFEaUVKBf+9PQvDG50Ry3rfAkoV
         LCvgXreq14KEkWnyFwiWU6fhUy1pBU/tx3Y4n+H12ax6Vn/AI7dMOQlVka1J5axAmQ
         ocGvRj8CCCcnlhfxrDC76O0NA599zPER+hsSybBVQNFmPrhutABz9O+oUUocpw1Bgi
         UeaBzWWZinoy5iSTQbDBuT1sHQxYmf6zLDEcCkcPhgiwj46WT/4vb7yV6fQbpsMxel
         8PQPHmJpI57U3vhLB/4+Yqh4oJ5Js25Wz10SIfxnTiBGVwEwX8Pb6agDUQK411NqHd
         rlpQsthsPHk3A==
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/30/20 3:08 AM, Daniel Vetter wrote:
> We want all iomem mmaps to consistently revoke ptes when the kernel
> takes over and CONFIG_IO_STRICT_DEVMEM is enabled. This includes the
> pci bar mmaps available through procfs and sysfs, which currently do
> not revoke mappings.
>=20
> To prepare for this, move the code from the /dev/kmem driver to
> kernel/resource.c.

This seems like it's doing a lot more than just code movement, right?
Should we list some of that here?

Also, I'm seeing a crash due to this commit. More below:

>=20
> Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: Daniel Vetter <daniel.vetter@intel.com>
> Cc: Jason Gunthorpe <jgg@ziepe.ca>
> Cc: Kees Cook <keescook@chromium.org>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: John Hubbard <jhubbard@nvidia.com>
> Cc: J=C3=A9r=C3=B4me Glisse <jglisse@redhat.com>
> Cc: Jan Kara <jack@suse.cz>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Cc: linux-mm@kvack.org
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-samsung-soc@vger.kernel.org
> Cc: linux-media@vger.kernel.org
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
> Cc: David Hildenbrand <david@redhat.com>
> Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
> Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
> --
> v3:
> - add barrier for consistency and document why we don't have to check
>    for NULL (Jason)
> v4
> - Adjust comments to reflect the general nature of this iomem revoke
>    code now (Dan)
> ---
>   drivers/char/mem.c     |  85 +---------------------------------
>   include/linux/ioport.h |   6 +--
>   kernel/resource.c      | 101 ++++++++++++++++++++++++++++++++++++++++-
>   3 files changed, 102 insertions(+), 90 deletions(-)
>=20
> diff --git a/drivers/char/mem.c b/drivers/char/mem.c
> index 7dcf9e4ea79d..43c871dc7477 100644
> --- a/drivers/char/mem.c
> +++ b/drivers/char/mem.c
> @@ -31,9 +31,6 @@
>   #include <linux/uio.h>
>   #include <linux/uaccess.h>
>   #include <linux/security.h>
> -#include <linux/pseudo_fs.h>
> -#include <uapi/linux/magic.h>
> -#include <linux/mount.h>
>  =20
>   #ifdef CONFIG_IA64
>   # include <linux/efi.h>
> @@ -836,42 +833,6 @@ static loff_t memory_lseek(struct file *file, loff_t=
 offset, int orig)
>   	return ret;
>   }
>  =20
> -static struct inode *devmem_inode;
> -
> -#ifdef CONFIG_IO_STRICT_DEVMEM
> -void revoke_devmem(struct resource *res)
> -{
> -	/* pairs with smp_store_release() in devmem_init_inode() */
> -	struct inode *inode =3D smp_load_acquire(&devmem_inode);
> -
> -	/*
> -	 * Check that the initialization has completed. Losing the race
> -	 * is ok because it means drivers are claiming resources before
> -	 * the fs_initcall level of init and prevent /dev/mem from
> -	 * establishing mappings.
> -	 */
> -	if (!inode)
> -		return;
> -
> -	/*
> -	 * The expectation is that the driver has successfully marked
> -	 * the resource busy by this point, so devmem_is_allowed()
> -	 * should start returning false, however for performance this
> -	 * does not iterate the entire resource range.
> -	 */
> -	if (devmem_is_allowed(PHYS_PFN(res->start)) &&
> -	    devmem_is_allowed(PHYS_PFN(res->end))) {
> -		/*
> -		 * *cringe* iomem=3Drelaxed says "go ahead, what's the
> -		 * worst that can happen?"
> -		 */
> -		return;
> -	}
> -
> -	unmap_mapping_range(inode->i_mapping, res->start, resource_size(res), 1=
);
> -}
> -#endif
> -
>   static int open_port(struct inode *inode, struct file *filp)
>   {
>   	int rc;
> @@ -891,7 +852,7 @@ static int open_port(struct inode *inode, struct file=
 *filp)
>   	 * revocations when drivers want to take over a /dev/mem mapped
>   	 * range.
>   	 */
> -	filp->f_mapping =3D inode->i_mapping;
> +	filp->f_mapping =3D iomem_get_mapping();


The problem is that iomem_get_mapping() returns NULL for the !CONFIG_IO_STR=
ICT_DEVMEM
case. And then we have pre-existing fs code that expects to go "up and over=
", like this:


static int do_dentry_open(struct file *f,
			  struct inode *inode,
			  int (*open)(struct inode *, struct file *))
{
...

	file_ra_state_init(&f->f_ra, f->f_mapping->host->i_mapping);

...and it crashes on that line fairly early in bootup.

Not sure what to suggest for this patch, but wanted to get this report out =
at least.

thanks,
--=20
John Hubbard
NVIDIA

>  =20
>   	return 0;
>   }
> @@ -1023,48 +984,6 @@ static char *mem_devnode(struct device *dev, umode_=
t *mode)
>  =20
>   static struct class *mem_class;
>  =20
> -static int devmem_fs_init_fs_context(struct fs_context *fc)
> -{
> -	return init_pseudo(fc, DEVMEM_MAGIC) ? 0 : -ENOMEM;
> -}
> -
> -static struct file_system_type devmem_fs_type =3D {
> -	.name		=3D "devmem",
> -	.owner		=3D THIS_MODULE,
> -	.init_fs_context =3D devmem_fs_init_fs_context,
> -	.kill_sb	=3D kill_anon_super,
> -};
> -
> -static int devmem_init_inode(void)
> -{
> -	static struct vfsmount *devmem_vfs_mount;
> -	static int devmem_fs_cnt;
> -	struct inode *inode;
> -	int rc;
> -
> -	rc =3D simple_pin_fs(&devmem_fs_type, &devmem_vfs_mount, &devmem_fs_cnt=
);
> -	if (rc < 0) {
> -		pr_err("Cannot mount /dev/mem pseudo filesystem: %d\n", rc);
> -		return rc;
> -	}
> -
> -	inode =3D alloc_anon_inode(devmem_vfs_mount->mnt_sb);
> -	if (IS_ERR(inode)) {
> -		rc =3D PTR_ERR(inode);
> -		pr_err("Cannot allocate inode for /dev/mem: %d\n", rc);
> -		simple_release_fs(&devmem_vfs_mount, &devmem_fs_cnt);
> -		return rc;
> -	}
> -
> -	/*
> -	 * Publish /dev/mem initialized.
> -	 * Pairs with smp_load_acquire() in revoke_devmem().
> -	 */
> -	smp_store_release(&devmem_inode, inode);
> -
> -	return 0;
> -}
> -
>   static int __init chr_dev_init(void)
>   {
>   	int minor;
> @@ -1086,8 +1005,6 @@ static int __init chr_dev_init(void)
>   		 */
>   		if ((minor =3D=3D DEVPORT_MINOR) && !arch_has_dev_port())
>   			continue;
> -		if ((minor =3D=3D DEVMEM_MINOR) && devmem_init_inode() !=3D 0)
> -			continue;
>  =20
>   		device_create(mem_class, NULL, MKDEV(MEM_MAJOR, minor),
>   			      NULL, devlist[minor].name);
> diff --git a/include/linux/ioport.h b/include/linux/ioport.h
> index 5135d4b86cd6..02a5466245c0 100644
> --- a/include/linux/ioport.h
> +++ b/include/linux/ioport.h
> @@ -307,11 +307,7 @@ struct resource *devm_request_free_mem_region(struct=
 device *dev,
>   struct resource *request_free_mem_region(struct resource *base,
>   		unsigned long size, const char *name);
>  =20
> -#ifdef CONFIG_IO_STRICT_DEVMEM
> -void revoke_devmem(struct resource *res);
> -#else
> -static inline void revoke_devmem(struct resource *res) { };
> -#endif
> +extern struct address_space *iomem_get_mapping(void);
>  =20
>   #endif /* __ASSEMBLY__ */
>   #endif	/* _LINUX_IOPORT_H */
> diff --git a/kernel/resource.c b/kernel/resource.c
> index 3ae2f56cc79d..5ecc3187fe2d 100644
> --- a/kernel/resource.c
> +++ b/kernel/resource.c
> @@ -18,12 +18,15 @@
>   #include <linux/spinlock.h>
>   #include <linux/fs.h>
>   #include <linux/proc_fs.h>
> +#include <linux/pseudo_fs.h>
>   #include <linux/sched.h>
>   #include <linux/seq_file.h>
>   #include <linux/device.h>
>   #include <linux/pfn.h>
>   #include <linux/mm.h>
> +#include <linux/mount.h>
>   #include <linux/resource_ext.h>
> +#include <uapi/linux/magic.h>
>   #include <asm/io.h>
>  =20
>  =20
> @@ -1115,6 +1118,58 @@ resource_size_t resource_alignment(struct resource=
 *res)
>  =20
>   static DECLARE_WAIT_QUEUE_HEAD(muxed_resource_wait);
>  =20
> +static struct inode *iomem_inode;
> +
> +#ifdef CONFIG_IO_STRICT_DEVMEM
> +static void revoke_iomem(struct resource *res)
> +{
> +	/* pairs with smp_store_release() in iomem_init_inode() */
> +	struct inode *inode =3D smp_load_acquire(&iomem_inode);
> +
> +	/*
> +	 * Check that the initialization has completed. Losing the race
> +	 * is ok because it means drivers are claiming resources before
> +	 * the fs_initcall level of init and prevent iomem_get_mapping users
> +	 * from establishing mappings.
> +	 */
> +	if (!inode)
> +		return;
> +
> +	/*
> +	 * The expectation is that the driver has successfully marked
> +	 * the resource busy by this point, so devmem_is_allowed()
> +	 * should start returning false, however for performance this
> +	 * does not iterate the entire resource range.
> +	 */
> +	if (devmem_is_allowed(PHYS_PFN(res->start)) &&
> +	    devmem_is_allowed(PHYS_PFN(res->end))) {
> +		/*
> +		 * *cringe* iomem=3Drelaxed says "go ahead, what's the
> +		 * worst that can happen?"
> +		 */
> +		return;
> +	}
> +
> +	unmap_mapping_range(inode->i_mapping, res->start, resource_size(res), 1=
);
> +}
> +struct address_space *iomem_get_mapping(void)
> +{
> +	/*
> +	 * This function is only called from file open paths, hence guaranteed
> +	 * that fs_initcalls have completed and no need to check for NULL. But
> +	 * since revoke_iomem can be called before the initcall we still need
> +	 * the barrier to appease checkers.
> +	 */
> +	return smp_load_acquire(&iomem_inode)->i_mapping;
> +}
> +#else
> +static void revoke_iomem(struct resource *res) {}
> +struct address_space *iomem_get_mapping(void)
> +{
> +	return NULL;
> +}
> +#endif
> +
>   /**
>    * __request_region - create a new busy resource region
>    * @parent: parent resource descriptor
> @@ -1182,7 +1237,7 @@ struct resource * __request_region(struct resource =
*parent,
>   	write_unlock(&resource_lock);
>  =20
>   	if (res && orig_parent =3D=3D &iomem_resource)
> -		revoke_devmem(res);
> +		revoke_iomem(res);
>  =20
>   	return res;
>   }
> @@ -1782,4 +1837,48 @@ static int __init strict_iomem(char *str)
>   	return 1;
>   }
>  =20
> +static int iomem_fs_init_fs_context(struct fs_context *fc)
> +{
> +	return init_pseudo(fc, DEVMEM_MAGIC) ? 0 : -ENOMEM;
> +}
> +
> +static struct file_system_type iomem_fs_type =3D {
> +	.name		=3D "iomem",
> +	.owner		=3D THIS_MODULE,
> +	.init_fs_context =3D iomem_fs_init_fs_context,
> +	.kill_sb	=3D kill_anon_super,
> +};
> +
> +static int __init iomem_init_inode(void)
> +{
> +	static struct vfsmount *iomem_vfs_mount;
> +	static int iomem_fs_cnt;
> +	struct inode *inode;
> +	int rc;
> +
> +	rc =3D simple_pin_fs(&iomem_fs_type, &iomem_vfs_mount, &iomem_fs_cnt);
> +	if (rc < 0) {
> +		pr_err("Cannot mount iomem pseudo filesystem: %d\n", rc);
> +		return rc;
> +	}
> +
> +	inode =3D alloc_anon_inode(iomem_vfs_mount->mnt_sb);
> +	if (IS_ERR(inode)) {
> +		rc =3D PTR_ERR(inode);
> +		pr_err("Cannot allocate inode for iomem: %d\n", rc);
> +		simple_release_fs(&iomem_vfs_mount, &iomem_fs_cnt);
> +		return rc;
> +	}
> +
> +	/*
> +	 * Publish iomem revocation inode initialized.
> +	 * Pairs with smp_load_acquire() in revoke_iomem().
> +	 */
> +	smp_store_release(&iomem_inode, inode);
> +
> +	return 0;
> +}
> +
> +fs_initcall(iomem_init_inode);
> +
>   __setup("iomem=3D", strict_iomem);
>=20


