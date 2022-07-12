Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3F0C571211
	for <lists+kvm@lfdr.de>; Tue, 12 Jul 2022 08:01:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231514AbiGLGBQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Jul 2022 02:01:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229515AbiGLGBP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Jul 2022 02:01:15 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56A8B31DE4;
        Mon, 11 Jul 2022 23:01:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657605674; x=1689141674;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=niSDj7COpCoIbSKZJ94NOMMTydgv1jKW5ap9HCOE6ds=;
  b=ScRPWeh6QhuO5JW2FZN8s+9k8g4iycDVm81o7oKcroWOJjz8CV3fs7dB
   7xva8a2DPvpTIv+pDHvUa+XRUUi5eFMNQQ1ZOqHSxoPlMxRSefjSKUyVs
   TtELhwTmeS5al12WrCnMCtuwVB5LGZrE2fisVewNNQ7BhMfom/PeHS8po
   H7qrHXh5trtXBsScUxTU56O+iwyUcJFUmR1Mnb+dEidCm3w4/X6pk1pnC
   fRMZTEeQUQlesD/IURO037WX/y8KE1K78StKafjmTeill2zTua9jx+Mq7
   MqVE3RgmXzzaSFk8HGVVs1Etv+IKcua1VFCu13ucCGP3xVYw/wD48+rxg
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10405"; a="285588889"
X-IronPort-AV: E=Sophos;i="5.92,264,1650956400"; 
   d="scan'208";a="285588889"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2022 23:01:05 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,264,1650956400"; 
   d="scan'208";a="627773540"
Received: from lkp-server02.sh.intel.com (HELO 8708c84be1ad) ([10.239.97.151])
  by orsmga001.jf.intel.com with ESMTP; 11 Jul 2022 23:01:01 -0700
Received: from kbuild by 8708c84be1ad with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1oB8xB-0001n3-6O;
        Tue, 12 Jul 2022 06:01:01 +0000
Date:   Tue, 12 Jul 2022 14:00:40 +0800
From:   kernel test robot <lkp@intel.com>
To:     Dan Carpenter <error27@gmail.com>, Jason Gunthorpe <jgg@ziepe.ca>
Cc:     llvm@lists.linux.dev, kbuild-all@lists.01.org,
        Yishai Hadas <yishaih@nvidia.com>,
        Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Leon Romanovsky <leon@kernel.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] vfio/mlx5: clean up overflow check
Message-ID: <202207121350.fs2JOFWt-lkp@intel.com>
References: <YsbzgQQ4bg6v+iTS@kili>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YsbzgQQ4bg6v+iTS@kili>
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Dan,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on awilliam-vfio/next]
[also build test WARNING on rdma/for-next linus/master v5.19-rc6 next-20220711]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Dan-Carpenter/vfio-mlx5-clean-up-overflow-check/20220707-225657
base:   https://github.com/awilliam/linux-vfio.git next
config: i386-allyesconfig (https://download.01.org/0day-ci/archive/20220712/202207121350.fs2JOFWt-lkp@intel.com/config)
compiler: clang version 15.0.0 (https://github.com/llvm/llvm-project 6ce63e267aab79ca87bf63453d34dd3909ab978d)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/44607f8f3817e1af6622db7d70ad5bc457b8f203
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Dan-Carpenter/vfio-mlx5-clean-up-overflow-check/20220707-225657
        git checkout 44607f8f3817e1af6622db7d70ad5bc457b8f203
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=i386 SHELL=/bin/bash drivers/hid/ drivers/md/ drivers/vfio/pci/mlx5/

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

>> drivers/vfio/pci/mlx5/main.c:282:6: warning: comparison of distinct pointer types ('typeof (len) *' (aka 'unsigned int *') and 'typeof ((unsigned long)*pos) *' (aka 'unsigned long *')) [-Wcompare-distinct-pointer-types]
               check_add_overflow(len, (unsigned long)*pos, &requested_length))
               ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/overflow.h:67:15: note: expanded from macro 'check_add_overflow'
           (void) (&__a == &__b);                  \
                   ~~~~ ^  ~~~~
>> drivers/vfio/pci/mlx5/main.c:282:6: warning: comparison of distinct pointer types ('typeof (len) *' (aka 'unsigned int *') and 'typeof (&requested_length)' (aka 'unsigned long *')) [-Wcompare-distinct-pointer-types]
               check_add_overflow(len, (unsigned long)*pos, &requested_length))
               ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/overflow.h:68:15: note: expanded from macro 'check_add_overflow'
           (void) (&__a == __d);                   \
                   ~~~~ ^  ~~~
   2 warnings generated.


vim +282 drivers/vfio/pci/mlx5/main.c

   269	
   270	static ssize_t mlx5vf_resume_write(struct file *filp, const char __user *buf,
   271					   size_t len, loff_t *pos)
   272	{
   273		struct mlx5_vf_migration_file *migf = filp->private_data;
   274		unsigned long requested_length;
   275		ssize_t done = 0;
   276	
   277		if (pos)
   278			return -ESPIPE;
   279		pos = &filp->f_pos;
   280	
   281		if (*pos < 0 || *pos > ULONG_MAX ||
 > 282		    check_add_overflow(len, (unsigned long)*pos, &requested_length))
   283			return -EINVAL;
   284	
   285		if (requested_length > MAX_MIGRATION_SIZE)
   286			return -ENOMEM;
   287	
   288		mutex_lock(&migf->lock);
   289		if (migf->disabled) {
   290			done = -ENODEV;
   291			goto out_unlock;
   292		}
   293	
   294		if (migf->allocated_length < requested_length) {
   295			done = mlx5vf_add_migration_pages(
   296				migf,
   297				DIV_ROUND_UP(requested_length - migf->allocated_length,
   298					     PAGE_SIZE));
   299			if (done)
   300				goto out_unlock;
   301		}
   302	
   303		while (len) {
   304			size_t page_offset;
   305			struct page *page;
   306			size_t page_len;
   307			u8 *to_buff;
   308			int ret;
   309	
   310			page_offset = (*pos) % PAGE_SIZE;
   311			page = mlx5vf_get_migration_page(migf, *pos - page_offset);
   312			if (!page) {
   313				if (done == 0)
   314					done = -EINVAL;
   315				goto out_unlock;
   316			}
   317	
   318			page_len = min_t(size_t, len, PAGE_SIZE - page_offset);
   319			to_buff = kmap_local_page(page);
   320			ret = copy_from_user(to_buff + page_offset, buf, page_len);
   321			kunmap_local(to_buff);
   322			if (ret) {
   323				done = -EFAULT;
   324				goto out_unlock;
   325			}
   326			*pos += page_len;
   327			len -= page_len;
   328			done += page_len;
   329			buf += page_len;
   330			migf->total_length += page_len;
   331		}
   332	out_unlock:
   333		mutex_unlock(&migf->lock);
   334		return done;
   335	}
   336	

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
